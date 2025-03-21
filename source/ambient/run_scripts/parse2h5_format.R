parsedir =  "/Users/asabjor/projects/sc-devop/scQC/data/human/GSE229617/parse1"
parsedir =  "/Users/asabjor/projects/sc-devop/scQC/data/human/GSE229617/parse2"

library(Matrix)
library(DropletUtils)


genes = read.csv(file.path(parsedir,"all_genes.csv"))
cells = read.csv(file.path(parsedir,"cell_metadata.csv"))
M = readMM(file.path(parsedir,"DGE.mtx"))

rownames(M) = cells$bc_wells
genes$gene_unique = make.unique(genes$gene_name)
colnames(M) = genes$gene_unique

write.table(genes, file = file.path(parsedir,"gene_with_uniquename.csv"), sep=',')

M = t(M)

alldir = file.path(parsedir,"all")
cat("Writing all to ", alldir, "\n")
DropletUtils::write10xCounts(alldir, M, gene.id = genes$gene_id, gene.symbol = genes$gene_unique,  version="3",  overwrite=T)

samples = unique(cells$sample)
for (sample in samples){
    outdir =  file.path(parsedir,sample)
    cat("Writing to ", outdir , "\n")
    DropletUtils::write10xCounts(outdir, M[,cells$sample == sample], gene.id = genes$gene_id, gene.symbol = genes$gene_unique,  version="3", overwrite=T)
}