suppressPackageStartupMessages({
  library(DropletUtils)
  library(Matrix)
  library(rhdf5)
  library(argparse)
})
parser <- ArgumentParser()

parser$add_argument("-i", "--infile",  help="input h5 file")
parser$add_argument("-o", "--outfile",  help="output h5 file")
parser$add_argument("-f", "--fraction",  help="fraction of cells to keep", default = 0.25, type="double")

args <- parser$parse_args()


# Rscript subsample_cells.R -i /Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE218853/GSM6757771_rep1_raw_feature_bc_matrix.h5 -o /Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE218853/GSM6757771_rep1_raw_feature_bc_matrix_sub.h5
#args = list()
#args$infile = '/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE218853/GSM6757771_rep1_raw_feature_bc_matrix.h5'
#args$outfile = '/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE218853/GSM6757771_rep1_raw_feature_bc_matrix_sub.h5'
#args$fraction = 0.25


###################################
# read matrix.

path = args$infile
cat("Reading from ",path,"\n")


if (grepl("\\.h5$", path)){

data = h5read(path,"matrix/data")
indices = h5read(path,"matrix/indices")
indptr = h5read(path,"matrix/indptr")
shape =  h5read(path,"matrix/shape")

C <- sparseMatrix(
      i = indices + 1,
      p = indptr,
      x = data,
      dims = shape,
      repr = "T"
    )
gene.symbol =as.character(h5read(path, "matrix/features/name"))
gene.names = make.unique(gene.symbol, sep = "-")
gene.names = toupper(gene.names)
barcodes =as.character(h5read(path,  "matrix/barcodes"))
colnames(C) = barcodes
rownames(C) = gene.names

print(dim(C))
# remove droplets with 1 or 0 counts
nC = colSums(C)
C = C[,nC>1]

# rempve genes with no expression
nCG = rowSums(C)
C = C[nCG>0,]
sce <- SingleCellExperiment(assays = list(counts = C))

}else if (grepl("matrix.mtx.gz", path)){
  sce = DropletUtils::read10xCounts(dirname(path),  row.names = 'symbol', col.names = T)
  nC = colSums(counts(sce))
  sce = sce[,nC>1]
  nCG = rowSums(counts(sce))
  sce = sce[nCG>0,]
  rownames(sce) = toupper(rownames(sce))  ## May need to double check if this is enough!

}else{
  cat("Error! unknown input file format ", path, "\n")
  stop()
}


###################################
# subsample

nC = ncol(sce)
targetN = round(nC * args$fraction)

cat("Matrix with ", nC, " cells, subsample to ", targetN, "cells\n")

sce = sce[,sample(1:nC,targetN,replace=FALSE)]


###################################
# write h5.

if (file.exists(args$outfile)){ file.remove(args$outfile) }

cat("Writing to ",args$outfile,"\n")

DropletUtils::write10xCounts(args$outfile, x = counts(sce), type = 'HDF5', version = '3')

   