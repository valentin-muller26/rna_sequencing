#!/usr/bin/env bash
#SBATCH --time=01:00:00
#SBATCH --mem=25G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=samtools_sort
#SBATCH --output=/data/users/vmuller/rnaseq/log/samtools_sort_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/samtools_sort_%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=0-31


WORKDIR="/data/users/${USER}/rnaseq/"
LOGDIR="$WORKDIR/log"
SAMPLELIST="$WORKDIR/FASTQ/metadata/sample_list.txt"
OUTDIR=$WORKDIR/mapping


#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

#take the sample name, path to the read1 and read2 line by line 
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`


#sorting the bam file
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif samtools sort -m 1000 -@ 4 -o $OUTDIR/${SAMPLE}sorted.bam -T temp $OUTDIR/$SAMPLE.bam
