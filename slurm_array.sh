#!/bin/bash
#SBATCH --array=1-12
#SBATCH --time=00:10:00
#SBATCH --mem=1g
#SBATCH --cpus-per-task=1
#SBATCH --job-name=slurm_array
#SBATCH --output=array_%J.out
#SBATCH --error=array_%J.err
#SBATCH --partition=pibu_el8

# define variables
WORKDIR="/data/users/${USER}/rnaseq"
OUTDIR="$WORKDIR/QC_results"
SAMPLELIST="$WORKDIR/FASTQ/metadata/sample_list.txt"

SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`

OUTFILE="$OUTDIR/${SAMPLE}.txt"

############################


mkdir -p $OUTDIR

echo "Run task for $SAMPLE with $READ1 and $READ2 ..." > $OUTFILE

sleep 30
