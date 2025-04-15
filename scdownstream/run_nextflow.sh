#!/bin/bash
#SBATCH -A uppmax2025-2-292
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 48:00:00
#SBATCH -J nf-core
#SBATCH -e /proj/naiss2024-23-571/nobackup/scQC/scdownstream/reports/nf.SLURM_Job_id=%j.sderr
#SBATCH -o /proj/naiss2024-23-571/nobackup/scQC/scdownstream/reports/nf.SLURM_Job_id=%j.sdout


# compute projects:
# uppmax2025-2-292 - NBIS project.
# naiss2024-22-1461 - Roy project 

module load bioinfo-tools
module load Nextflow
module load nf-core

cd /proj/naiss2024-23-571/nobackup/scQC/scdownstream/



#  INFO:    Environment variable SINGULARITYENV_TMPDIR is set, but APPTAINERENV_TMPDIR is preferred
#  INFO:    Environment variable SINGULARITYENV_NXF_TASK_WORKDIR is set, but APPTAINERENV_NXF_TASK_WORKDIR is preferred
#  INFO:    Environment variable SINGULARITYENV_NXF_DEBUG is set, but APPTAINERENV_NXF_DEBUG is preferred
#  INFO:    Environment variable SINGULARITYENV_SNIC_TMP is set, but APPTAINERENV_SNIC_TMP is preferred


export NXF_HOME=$PWD
export APPTAINERENV_CACHEDIR=${PWD}/SINGULARITY_CACHEDIR
export SINGULARITY_CACHEDIR=${PWD}/SINGULARITY_CACHEDIR
export APPTAINERENV_TMPDIR=${PWD}/SINGULARITY_TMPDIR
export SINGULARITY_TMPDIR=${PWD}/SINGULARITY_TMPDIR
export NXF_APPTAINERENV_CACHEDIR=${APPTAINERENV_CACHEDIR}
export NXF_SINGULARITY_CACHEDIR=${APPTAINERENV_CACHEDIR}
export MPLCONFIGDIR=${PWD}/MATPLOTLIB_CACHEDIR
mkdir -p SINGULARITY_CACHEDIR SINGULARITY_TMPDIR MATPLOTLIB_CACHEDIR


# naiss2024-22-1150 - wabi project
# naiss2024-22-1461 = roy sc project


#nextflow run nf-core/scdownstream -r dev -params-file params.yaml  -profile uppmax --project naiss2024-22-1461 -resume

#nextflow run nf-core/scdownstream -r dev -params-file params.yaml -c custom_base.config -profile uppmax --project naiss2024-22-1461 -resume --clusterOptions "-C mem256GB -p node" --max_memory "256GB"

nextflow run nf-core/scdownstream -r dev -params-file params.yaml -c custom_base.config -profile uppmax --project uppmax2025-2-292 -resume --clusterOptions "-C mem2\
56GB -p node" --max_memory "256GB"


# increased memory with:
#--clusterOptions "-C mem256GB -p node" --max_memory "256GB"

