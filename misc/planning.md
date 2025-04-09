## Wishlist

- Background - cellbender, with report on bg signal, or other method.
	- BG score per cell to include in QC plots.
- Emptydrops? Or use cellbender for barcode calls.
- Doublet detection, multiple methods?
- Features, C,F,Mt,Ribo,Hb, PC, ncRNA - all last after mito removal.
	- QC per sample
	- QC per celltype/sample
- Filtering suggestions.
- Cell cycle
- Check sex if mouse/human
- Celltype prediction.
- Check for batch effects - what is best method?
- Percentage top genes.
	- Suggested filtering of genes?
- Gene biotype proportions per sample.
- Stress signal?
- Umap colored by different features, also per dataset??
- Inputs/outputs - should be able to take cellranger, parse output as well as Seurat-object, SCE, AnnData. Also, different output options.

#### Possible additions in future
- Hashing
- More than RNA assay, CITE/VDJ/ATAC
- Interactive viewer after QC for selecting QC filters.
- Percent spliced/unspliced, if running velocity pipeline

## scdownstream vs wishlist

[scdownstream](https://nf-co.re/scdownstream/dev/) nf-core pipeline has most of the features we need:

- scd has most of the features that we need:
	- empty droplet removal.
	- ambient RNA removal
	- cell filtering - but very limited.
	- downstreamd integration, umap, clustering.
- Missing is:
	- For empty droplet calling - include emptydrops
	- Dynamical filtering of cells - see example in qc_summary.html
	- Gene biotype information: If gtf available use that for biotypes, otherwise use biomart?
		- as violins
		- as proportion barplots.
	- Gene filtering - at least mito removal, but possibly pc genes selection? Hard to specify specific ncRNA in a pipeline.
	- Celltype prediction - include a broad predictor like singleR HPCA, already started in branch https://github.com/nf-core/scdownstream/tree/24-implement-singler-cell-type-assignment
	  	- also, the turkish group doing a hackathon also suggested celltyping. https://github.com/KurayiChawatama/nf-core-March-2025-Hackathon-scdownstream-Pipeline-Improvement-Project
		- scimilarity was just implemented into the pipeline. Needs gpu? 
	- Sample sex plots? Possibly also crosscheck with metadata if available. Implement for mouse and human to start with, possibly extend to more species. Simplyfy with list of non-PAR chrY genes.
	- More extensive report is needed, now multiqc report. 
	- Option to have umap/clustering without integration, probably already possible.
- Many QC tools in scd are not yet shared modules, we can probably get help from Nico in creating shared modules.
- Reports options:
	- Multiqc based, for now has static images exported at different steps.
	- .qmd based, similar to what is used in spatialvi pipeline. 
	- .Rmd based, examples in the scflow pipeline https://github.com/combiz/scFlow/blob/master/inst/rmarkdown/templates/merged-quality-control/skeleton/skeleton.Rmd
	- Examples of reports in this [drive folder](https://drive.google.com/drive/folders/1mAfAw0IBc4j_w_aX7jZEz0dVFbqYEg4V?usp=sharing) 
		- multiqc report is from scdownstream tested with 3 samples.
		- qc_overview.html is summary from Åsa.
		- example reports from scflow. 
	- Can be one large report or multiple shorter reports. 




## Existing tools

- scQCEA - https://isarnassiri.github.io/scQCEA/, july 2023
- SCTK-QC pipeline, singleCellTK_ R package. The SCTK-QC pipeline. March 2022
- SCTK2 - Aug 2023 https://www.sciencedirect.com/science/article/pii/S2666389923001824
- scRNABatchQC - Dec 2019 - mainly for detecting batch effects, pathway enrichment of HVGs and PC genes with Gestalt. Also QC 
- Include cluster QC? 
	- ddQC, 
	- ctQC (https://www.biorxiv.org/content/10.1101/2024.05.23.594978v1.full)
		- Nice illustration of Celltype QC in fig1 #scCourse/lectures 
	- scAutoQC https://teichlab.github.io/sctk/notebooks/automatic_qc.html. https://www.biorxiv.org/content/10.1101/2024.10.11.614415v1.full
		- Does dimred and clustering on QC paramters, then defines outlier clusters. 

- Bollito - snakemake pipeline for whole analysis. Also includes FastQC and RSeQC for alignment quality.
- Shaoxia - https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-024-10322-1, Web based pipeline, only QC on C,F,Mt,Ribo, April 2024
- Review in https://www.sciencedirect.com/science/article/pii/S1016847824001286, also useful for #scCourse/lectures

|           | scQCEA           | SCTK-QC                 | SCTK2                    | scRNABatchQC | Bollito                    |
| --------- | ---------------- | ----------------------- | ------------------------ | ------------ | -------------------------- |
| Language  | R                | R/Seurat                | R/Seurat                 | R/Bioc       | Snakemake                  |
| Objects   |                  | All                     | All                      |              |                            |
| Backgound |                  | DecontX                 | DecontX/SoupX            |              |                            |
| Empty D   |                  | EmptyDrops, BarcodeRank | EmptyDrops, BarcodeRank  |              |                            |
| Double    |                  | 6 methods               | 6 methods                |              |                            |
| Celltype  | AUCell with HPCA |                         | SingleR (after analysis) |              | MSigDB and DGE per cluster |
| Features  | C,F,Mt           | C,F,Mt                  |                          | C,F,Mt,Ribo  | C,F,Mt,Ribo                |
| Top Genes |                  |                         | Included                 |              |                            |
|           |                  |                         |                          |              |                            |
|           |                  |                         |                          |              |                            |



Features: C=nCounts, F=nFeatures, Mt=percent Mito, Ribo=PercentRibo


#### Doublet detectors

- scDblFinder
- DoubletFinder
- Scrublet
- cxds
- bcds


