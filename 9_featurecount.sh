#!/usr/bin/env bash
#SBATCH --time=02:00:00
#SBATCH --mem=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=featurecount
#SBATCH --output=/data/users/vmuller/rnaseq/log/featurecount_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/featurecount_%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=1-16

WORKDIR="/data/users/${USER}/rnaseq/"
LOGDIR="$WORKDIR/log"
SAMPLELIST="$WORKDIR/FASTQ/metadata/sample_list.txt"
MAPPINGDIR="$WORKDIR/mapping"
OUTDIR="$WORKDIR/counts"
ANNOTATIONFILE="$WORKDIR/reference_genome/Mus_musculus.GRCm39.113.gtf"


#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

mkdir -p $OUTDIR

#unzip the annotation file 
gunzip $ANNOTATIONFILE.gz

#take the sample name, path to the read1 and read2 line by line 
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`

apptainer exec --bind $WORKDIR /containers/apptainer/subread_2.0.1–hed695b0_0.sif featureCounts -T4 -p --countReadPairs -s2 -t exon -g gene_id -a $ANNOTATIONFILE -o $OUTDIR/${SAMPLE}_count.txt $MAPPINGDIR/${SAMPLE}.bam