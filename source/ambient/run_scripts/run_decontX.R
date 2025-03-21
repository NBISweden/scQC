library(decontX)
library(SingleCellExperiment)
library(Seurat)

# run decontX on the cells selected by cellbender 
# since not all datasets have a filtered matrix from cellranger

force = FALSE

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


#########################################

read_mtx = function(mtxfile, path){
  # create symlinks to the files with prefix and read in mtx.
  tmpdir = "tmp_mtx2"
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

#########################################
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
  cb_file =  file.path(resdir,sname,"cellbender","cellbender_out_cell_barcodes.csv")
  
  outdir = file.path(resdir,sname,"decontX")
  dir.create(outdir, showWarnings = F, recursive = T)
  
  outfile = file.path(outdir,"decontX_cormat.h5")
  if (file.exists(outfile) & !force){
    print(paste0("Done for ",outfile))
    next
  }

  print(paste0("Running ",outfile))
  
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
  
  sce <- SingleCellExperiment(list(counts = counts.filt))
  sce.raw <- SingleCellExperiment(list(counts = counts.raw))

  rm(counts.filt, counts.raw)
  gc()

  # can provide clusters ourself, but it also runs its own estimation of clusters.
  sce <- decontX(sce, background = sce.raw)
  write.csv(colData(sce),file.path(outdir,"decontX_cell_metadata.csv") )
  DropletUtils::write10xCounts(outfile, sce@assays@data$decontXcounts, type = "HDF5",
                             genome = "mm10", version = "3", overwrite = TRUE,
                             gene.id = rownames(sce), gene.symbol = rownames(sce))
}


# now have addtional slots:
# assays(2): counts decontXcounts
# colData names(2): decontX_contamination decontX_clusters
# reducedDimNames(1): decontX_UMAP
                             