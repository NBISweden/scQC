## NBIS single cell QC pipeline

Dates:

* *5th of May*, 13-16, on-line, nf-core session. Everyone is expected to know the basics of nextflow by completing the tutorial at the [reproducibility course](https://nbisweden.github.io/workshop-reproducible-research/pages/nextflow.html). Erik and Mahesh will go through the details of nf-core vs nextflow and show some examples.
* *21st of May*, 10-17, in Stockholm or on-line, Hackathon. More information on the exact details will come later.


General info:

* Thougths on what should be in the pipeline [here](misc/planning.md)
* Suggested [datasets](misc/data.md)
* Meeting notes [here](misc/meetings.md)


For now a collection of scripts for different parts of the analysis:

* `source/ambient/` folder contains methods for ambient RNA estimation. Cellbender, SoupX and DecontX was run and overview is found in `source/ambient/analysis/ambient_methods_overview.qmd`
* `source/all_qc/` contains all other kinds of QC, most of it in one large summary at `qc_overview.qmd`
