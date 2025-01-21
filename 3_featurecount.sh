#!/usr/bin/env bash
#SBATCH --time=02:00:00
#SBATCH --mem=1G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=featurecount
#SBATCH --output=/data/users/vmuller/rnaseq/log/featurecount_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/featurecount_%J.err
#SBATCH --partition=pibu_el8

#Setting the constant for the directory and the required files
WORKDIR="/data/users/${USER}/rnaseq"
LOGDIR="$WORKDIR/log"
SAMPLELIST="$WORKDIR/FASTQ/metadata/sample_list.txt"
MAPPINGDIR="$WORKDIR/mapping"
OUTDIR="$WORKDIR/counts"
ANNOTATIONFILE="$WORKDIR/reference_genome/Mus_musculus.GRCm39.113.gtf"


#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

#Create the output directory
mkdir -p $OUTDIR

#Take the sample name, path to the read1 and read2 line by line 
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`

#Generate the table of counts
apptainer exec --bind $WORKDIR /containers/apptainer/subread_2.0.1--hed695b0_0.sif featureCounts -T4 -p -s2 -Q10 -t exon -g gene_id -a $ANNOTATIONFILE -o "$OUTDIR/gene_count.txt" $MAPPINGDIR/*sorted.bam

