## NBIS single cell QC pipeline


* Thougths on what should be in the pipeline [here](misc/planning.md)
* Suggested [datasets](misc/data.md)
* Meeting notes [here](misc/meetings.md)


For now a collection of scripts for different parts of the analysis:

* `source/ambient/` folder contains methods for ambient RNA estimation. Cellbender, SoupX and DecontX was run and overview is found in `source/ambient/analysis/ambient_methods_overview.qmd`
* `source/all_qc/` contains all other kinds of QC, most of it in one large summary at `qc_overview.qmd`
