library(SoupX)
library(dplyr)
library(Seurat)

# run soupX on the cells selected by cellbender 
# since not all datasets have a filtered matrix from cellranger
# run the seurat pipeline in a separate step and save to file 

resdir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/output/"

#indir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE213825/"  
#split.idx = 2

#indir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE218853/"  
#split.idx = 2

indir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE229059/"  
split.idx = 1

#indir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE261852/"  
#split.idx = 3

sfiles = dir(indir,"raw")

# dataset with mtx format!
#indir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE244142/"  
#split.idx = 1:2
#sfiles = dir(indir,"mtx")


# The human data all have mtx format 
indir="/Users/asabjor/projects/sc-devop/scQC/data/human/GSE229617"
resdir="/Users/asabjor/projects/sc-devop/scQC/data/human/output"
split.idx = 1:2
sfiles = list.dirs(indir, full.names=F)[-1]



###############################################

force = FALSE # force rerun  pipeline.

# try with different resolutions
resolutions = c(0.2,0.4,0.6, 0.8,1.0)

# allow for maximum contamination fraction at 0.5 
# otherwise throws errors
max.rho = 0.5

###############################################

read_mtx = function(mtxfile, path){
  # create symlinks to the files with prefix and read in mtx.
  tmpdir = "tmp_mtx"
  dir.create(tmpdir, showWarnings = F)
  
  ffile = sub("matrix.mtx", "features.tsv",mtxfile)
  bfile = sub("matrix.mtx", "barcodes.tsv",mtxfile)

  file.symlink(file.path(path,mtxfile), file.path(tmpdir,"matrix.mtx.gz"))
  file.symlink(file.path(path,ffile), file.path(tmpdir,"features.tsv.gz"))
  file.symlink(file.path(path,bfile), file.path(tmpdir,"barcodes.tsv.gz"))
  
  c = Read10X(tmpdir)
  # then remove the symlinks!
  file.remove(file.path(tmpdir,"matrix.mtx.gz"))
  file.remove(file.path(tmpdir,"features.tsv.gz"))
  file.remove(file.path(tmpdir,"barcodes.tsv.gz"))
  
  return(c)
   
}
  


run_seurat = function(counts, resolutions = c(0.2,0.4,0.6, 0.8,1.0), force = F, savefile = "sobj_unfilt.rds") {
  if (!force & file.exists(savefile)){
    sobj = readRDS(savefile)
  }else{
    sobj = CreateSeuratObject(counts)
    sobj = sobj %>% NormalizeData(verbose = F) %>% 
      FindVariableFeatures(verbose = F) %>% ScaleData(verbose = F)
    sobj = sobj %>% RunPCA(verbose = F) %>% 
      RunUMAP(dims=1:30, verbose = F) %>% FindNeighbors(dims = 1:30, verbose = F)   
    for (res in resolutions){
      sobj = FindClusters(sobj, resolution = res, verbose = F )
    } 
    saveRDS(sobj,savefile)
  }
  return(sobj)
}

###############################################
# run one sample at a time

for (sfile in sfiles){
  if (grepl("parse[12]$",sfile) ) { next }
  if (grepl("parse",sfile)){
     sname = sub("/","_",sfile)
  }else{
     sname = paste(unlist(strsplit(sfile,"_"))[split.idx], collapse = "_")
     sname = gsub("_NA","",sname)
  }
  raw_file = file.path(indir,sfile)
  seu_file = file.path(resdir,sname,"sobj_unfiltered.rds")
  cb_file =  file.path(resdir,sname,"cellbender","cellbender_out_cell_barcodes.csv")
  
  outdir = file.path(resdir,sname,"soupX")
  dir.create(outdir, showWarnings = F, recursive = T)

  if (grepl(".h5", sfile)){
    counts.raw = Read10X_h5(raw_file)
  }else if (dir.exists(raw_file)){ # if it is a directory instead.
    counts.raw = Read10X(raw_file)	
  }else{
    counts.raw = read_mtx(sfile,indir)
  }
  # for multiseq returns a list of matrices
  if (class(counts.raw) == 'list'){ counts.raw = counts.raw[["Gene Expression"]] } 

  cb_barcodes = read.csv(cb_file, header = F)
  counts.filt = counts.raw[,cb_barcodes[,1]]
  
  # run seurat pipeline for the filtered cells to get the clusters
  sobj = run_seurat(counts.filt, force=force, savefile = seu_file, resolutions = resolutions)
    
  
  for (res in resolutions) { 
    print(sprintf("running resolution: %.1f",res))
    clust = paste0("RNA_snn_res.",as.character(res))
    if (nrow(unique(sobj[[clust]])) == 1) { cat("Only a single cluster for ", sfile, " at resolution", clust, "\n"); next}


    outfile = file.path(outdir,paste0("soupX_cormat_",res,".h5"))
    if (file.exists(outfile) & !force){
      print(paste0("file exists: ",outfile))
      next
    }
    
#    plotfile = file.path(outdir,paste0("soupX_stats_",res,".pdf"))
#    pdf(plotfile)
    
   
#    p1 = DimPlot(sobj, group.by = clust, label = T) + NoAxes() 
#    print(p1)
    
    # create soup object
    sc = SoupChannel(counts.raw, counts.filt, calcSoupProfile = FALSE)
    sc = estimateSoup(sc)
  
    # need to add cluster information
    sc = setClusters(sc, setNames(sobj[[clust]][,1], colnames(sobj)))

    # check first if any genes pass the filters
    mrks = quickMarkers(sc$toc,sc$metaData$clusters,N=Inf)
    tf.cut = 1 #default value.
    gene_pass = intersect(mrks$gene[mrks$tfidf>tf.cut], rownames(sc$soupProfile)[sc$soupProfile$est>quantile(sc$soupProfile$est,0.9)])
    if (length(gene_pass) <= 10){
       tf.cut = quantile(mrks$tfidf,0.98)
       gene_pass = intersect(mrks$gene[mrks$tfidf>tf.cut], rownames(sc$soupProfile)[sc$soupProfile$est>quantile(sc$soupProfile$est,0.9)])
       if (length(gene_pass) < 10) {
       	  cat("Not enough genes for soupX, skipping ", outfile)
	  next
       }
    } 

    sc = autoEstCont(sc, forceAccept = TRUE, tfidfMin=tf.cut)
    

    if (sc$fit$rhoEst > max.rho) { 
      sc = setContaminationFraction(sc, max.rho)
    }
    
    # plot top bg markers, gives error with high contaminant fraction.
    #p = plotMarkerDistribution(sc)
    #print(p)
    #dev.off()  

        # adjusted counts
    out = adjustCounts(sc)
    DropletUtils::write10xCounts(outfile, out, type = "HDF5",
                genome = "mm10", version = "3", overwrite = TRUE,
                gene.id = rownames(out), gene.symbol = rownames(out))
      
  }
  
}

# 276 genes passed tf-idf cut-off and 63 soup quantile filter.  Taking the top 63.
# Using 627 independent estimates of rho.
# Estimated global rho of 0.46
# Warning message:
#   In setContaminationFraction(sc, contEst, forceAccept = forceAccept) :
#   Estimated contamination is very high (0.46).

# >   out = adjustCounts(sc)
# Expanding counts from 29 clusters to 21604 cells.
# Warning message:
#   In sparseMatrix(i = out@i[w] + 1, j = out@j[w] + 1, x = out@x[w],  :
#                     'giveCsparse' is deprecated; setting repr="T" for you
                             