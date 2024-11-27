#!/usr/bin/env bash
#SBATCH --time=01:00:00
#SBATCH --mem=1G
#SBATCH --cpus-per-task=2
#SBATCH --job-name=FastQC
#SBATCH --output=/data/users/vmuller/rnaseq/log/Fastqc_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/Fastqc_%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=0-31

#Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq"
OUTDIR="$WORKDIR/QC_results"
SAMPLELIST="$WORKDIR/FASTQ/metadata/sample_list.txt"
LOGDIR="$WORKDIR/log"

#Create the directory for the error and output file if not present
mkdir -p $LOGDIR


#take the sample name, path to the read1 and read2 line by line 
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`

#Create the directory output if not present
mkdir -p $OUTDIR
cd $OUTDIR

#run fastqc for both read and put the result in the outdir
apptainer exec --bind /data /containers/apptainer/fastqc-0.12.1.sif fastqc -t 2 $READ1 $READ2 -o $OUTDIR
