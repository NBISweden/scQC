## Planning meeting 250321 13:00

* Presentation on ambient RNA in scRNAseq and some comparisons that have been done (../source/ambient/ambient_presentation/index).
* Discussion on how to deal with ambient RNA, should we recommend removal, or should we at least have as default in our pipelines to flag presence of ambient RNA. Probably best to start with the latter.
* Looking at the plans for QC report - main parts to include listed in wishlist at (./planning). 
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




