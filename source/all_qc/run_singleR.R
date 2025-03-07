suppressPackageStartupMessages({
  library(SingleR)
  library(Matrix)
  library(rhdf5)
  library(argparse)
  library(SingleCellExperiment)
})


parser <- ArgumentParser()
parser$add_argument("-i", "--infile",  help="input raw h5 file")
parser$add_argument("-o", "--outfile",  help="output file")
parser$add_argument("-d", "--dropsfile",  help="path to emptydrops cell_stats.csv file")
parser$add_argument("-s", "--species",  help="species, for now only mouse or human")

args <- parser$parse_args()

# Rscript run_singleR.R -i /Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE218853/GSM6757771_rep1_raw_feature_bc_matrix.h5 
# -o /Users/asabjor/projects/sc-devop/scQC/data/mouse/output/singler/GSM6757771_rep1
# -d /Users/asabjor/projects/sc-devop/scQC/data/mouse/output/emptydrops/GSM6757771_rep1/cell_stats.csv
# -s mouse

#args = list()
#args$infile = '/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE218853/GSM6757771_rep1_raw_feature_bc_matrix.h5'
#args$dropsfile =  '/Users/asabjor/projects/sc-devop/scQC/data/mouse/output/emptydrops/GSM6757771_rep1/cell_stats.csv'
#args$outfile = '/Users/asabjor/projects/sc-devop/scQC/data/mouse/output/singler/GSM6757771_rep1_singler.csv'
#args$species = 'mouse'

accepted_species = c("mouse","human")
if (! args$species %in% accepted_species ){
  stop(paste(c("Error! Accepted species are ", accepted_species, "\nYou priovided", args$species), collapse = ": "))
}
if (!file.exists(args$dropsfile)){  stop(paste0("Error! No file : ", args$dropsfile)) }
if (!file.exists(args$infile)){  stop(paste0("Error! No file : ", args$infile)) }

#########################################
# Reading in emptyDrops cell predictions
#########################################


drops = read.csv(args$dropsfile)
drops = drops[!is.na(drops$FDR) & drops$FDR <= 0.05,]

#########################################
### Reading in full count matrix.
#########################################

cat("Reading from ",args$infile,"\n")

data = h5read(args$infile,"matrix/data")
indices = h5read(args$infile,"matrix/indices")
indptr = h5read(args$infile,"matrix/indptr")
shape =  h5read(args$infile,"matrix/shape")

C <- sparseMatrix(
      i = indices + 1,
      p = indptr,
      x = data,
      dims = shape,
      repr = "T"
    )
gene.symbol =as.character(h5read(args$infile, "matrix/features/name"))
gene.names = make.unique(gene.symbol, sep = "-")
barcodes =as.character(h5read(args$infile,  "matrix/barcodes"))
colnames(C) = barcodes
rownames(C) = gene.names

C = C[,drops$X]
print(dim(C))

#########################################
#Running singleR 
#########################################

# create sce
sce <- SingleCellExperiment(assays = list(counts = C))

# load ref
if (args$species == "human"){
  ref <- celldex::HumanPrimaryCellAtlasData()
  cat("Running singleR with HumanPrimaryCellAtlasData reference\n")
}else if (args$species == "mouse"){
  ref = celldex::MouseRNAseqData()
  cat("Running singleR with MouseRNAseqData reference\n")
}

singler <- SingleR(test = sce, ref = ref, assay.type.test=1,
                        labels = ref$label.main)

cat("Writing to file ",args$outfile, "\n")
write.csv(singler, file= args$outfile)
cat("All done\n")