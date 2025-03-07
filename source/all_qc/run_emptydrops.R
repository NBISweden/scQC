suppressPackageStartupMessages({
  library(DropletUtils)
  library(Matrix)
  library(rhdf5)
  library(argparse)
})
parser <- ArgumentParser()

parser$add_argument("-i", "--infile",  help="input h5 file")
parser$add_argument("-o", "--outdir",  help="output directory")

args <- parser$parse_args()

# Rscript run_emptydrops.R -i /Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE218853/GSM6757771_rep1_raw_feature_bc_matrix.h5 -o /Users/asabjor/projects/sc-devop/scQC/data/mouse/output/emptydrops/GSM6757771_rep1_raw_feature_bc_matrix
#path = '/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE218853/GSM6757771_rep1_raw_feature_bc_matrix.h5'
#outpath =  '/Users/asabjor/projects/sc-devop/scQC/data/mouse/output/emptydrops/GSM6757771_rep1_raw_feature_bc_matrix'

path = args$infile
outpath = args$outdir
dir.create(outpath, showWarnings = F)

cat("Reading from ",path,"\n")


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

cat("Running emptyDrops\n")
ambient = emptyDrops(sce)

# cell stats in ambient
write.csv(ambient, file=file.path(outpath,"cell_stats.csv"))
write.csv(ambient@metadata, file=file.path(outpath,"gene_stats.csv"))

cat("All done\n")