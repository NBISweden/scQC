## Meeting 250409 10:00

* Brief background on what has been discussed before
* Summary of scdownstream developer Nico Trummer meeting (Erik/Åsa)
* List of parts that are missing in scdownstream in [planning doc](planning.md) under section "scdownstream vs wishlist".
* Main subtasks could be:
  * emptydrops module
  * singleR celltype module - continuation on what has been implemented already.
  * gene biotype information from gtf or via baiomart.
  * qc filtering script with dynamical or fixed filtering options
  * report - probably easiest to continue with .qmd report
  * pipeline optimization for pdc/uppmax or what resurces we will use. 
* We will set up a poll to divide tasks into subgroups after the nf-core session.
* Probably a good idea to have a intro of nextflow/nf-core for everyone. Have material at [reproducibility course](https://nbisweden.github.io/workshop-reproducible-research/pages/nextflow.html).
  * Plan is that everyone looks through the material from the course on their own.
  * Erik F will organize a session for explaining nf-core vs nextflow with some examples from the scdownstream pipeline. Will Ask Mahesh if he also can join.
  * Poll for suitable dates on the slack channel #scqc_pipeline. Finally the time 5th of May at 13:00 was decided. 
* For the actual hackathon we decided to have it on-site in Stockholm on 21st of xMay (day before cellmol meeting in Sth).
* Additional people that migth be interested are:
  * Nico and other scdownstream devs?
  * NGI bioinfo staff.
  * Other NBIS staff?
  * Åsa will send out information and ask if anyone is interested.


## Planning meeting 250321 13:00

* Presentation on ambient RNA in scRNAseq and some comparisons that have been done (../source/ambient/ambient_presentation/index).
* Discussion on how to deal with ambient RNA, should we recommend removal, or should we at least have as default in our pipelines to flag presence of ambient RNA. Probably best to start with the latter.
* Looking at the plans for QC report - main parts to include listed in wishlist in [planning doc](planning.md). 
* Seems like many parts of what is on the list is already in the nf-core pipeline https://nf-co.re/scdownstream/dev/
* Discussion on best way forward, should we build on the existing nf-core or start from scratch. Is some overhead to make it compliant with nf-core guidlines. Perhaps best to start with a fork and build own rules, then we can see later if they can be implemented in the main pipeline. We can at least start with nf-core templates.
* Reach out to the main developers of the nf-core pipeline and check if they want to collaborate. 
* Also check with NGI if they are interested in participating.
* Main thing that is missing in the pipeline is adaptive filtering and some other minor things, so probably not a big issue to add it in.
* But we would like a nice report to the users that can be produced by NGI as well, so the question is how that would look. 

Plan forward:
* Testrun the nf-core pipeline on the same datasets that were used for the ambient reports.
* Evaluate what is missing and if it fits our needs.
* We will use compute resources that Roy has at Rackham for now.
* Åsa will set up a slack channel for communication.
* Plan for a next meeting in about 2 weeks. Make poll in the slack channel.






