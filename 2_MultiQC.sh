#!/bin/bash
#SBATCH --time=00:10:00
#SBATCH --mem=100M
#SBATCH --cpus-per-task=1
#SBATCH --job-name=MultiQC
#SBATCH --output=/data/users/vmuller/rnaseq/log/Multiqc_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/Multiqc_%J.err
#SBATCH --partition=pibu_el8

FASTQCDIR="/data/users/${USER}/rnaseq/QC_results"
LOGDIR="/data/users/${USER}/rnaseq/log"

#Create the directory for the error and output file if not present
mkdir -p $LOGDIR


cd $FASTQCDIR
apptainer exec --bind $FASTQCDIR /containers/apptainer/multiqc-1.19.sif multiqc $FASTQCDIR -n multiqc_report.html