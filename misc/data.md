## Test datasets

Suggested datasets to use for testing the pipelines.


### Mouse data

A collection of publised mouse studies where also the raw (unfiltered) output from cellranger was available. The datasets are:


- Mouse root ganglia
        - Downloaded - has both raw/filtered .h5!
        - https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE213825
        - 16 samples. Names SAM24349928-SAM24374041
        - Has both raw and filtered h5 files submitted!
- Mouse tumors, snRNAseq
        - Downloaded - has mtx format, need to convert to h5!
        - https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE244142
        - 8 samples, organoids inplanted in mice.
                - names GSM7807801_SITTA8 - GSM7807808_SITTH9
        - Says it is raw matrix in supplementary files.
        - Super series with all data:
                - https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE243892
                - is also bulkRNAseq
- Mouse muscle with VDJ
        - Downloaded - has raw .h5
        - https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE229059
        - FACS sorted cells, what type?
        - 24 samples, but 8 with GEX, rest is VDJ, both BCR & TCR.
                - Names GSM7150713-GSM7150739
        - Groups of n=3-5 mice from indicated congenic strains of C57BL/6 mice were immunized intramuscularly with PBS versus recombinant HRS. 17-21 days post immunization, muscle tissue was harvested from mice and pooled by experimental group. Physical and enzymatic digestion of pooled muscle samples yielded single cell preparations that were then subjected to flow cytometry as well as scRNAseq using the 10X Genomics platform and 5'V2 chemistry.
- Mouse CAR-T cells
        - Downloaded - has raw .h5
        - https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE261852
        - 2 samples, both GEX and HTO files.  GSE261852_CI82_spl1, GSE261852_CI82_spl2
        - Both filtered and raw files submitted.
- The background removal paper
        - https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE218853
        - 3 mouse strains mixed, nuc and scRNAseq, kidney samles.
        - 5 samples, names, rep1-3 and nuc2,3
                - rep1 - 6% bg, >15K cells
                - rep2 - 11% bg, >15K cells
                - rep3 - 3% bg, <5K cells
                - nuc2 - 35 % bg, >15K cells - extra washing step.
                - nuc3 - 17% bg, <5K cells