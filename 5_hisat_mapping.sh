#!/usr/bin/env bash
#SBATCH --time=03:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=hisat_mapping
#SBATCH --output=/data/users/vmuller/rnaseq/log/hisat_mapping_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/hisat_mapping_%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=0-31



WORKDIR="/data/users/${USER}/rnaseq/"
REFGENDIR="$WORKDIR/reference_genome"
LOGDIR="$WORKDIR/log"
INDEXDIR="$WORKDIR/index_hisat"
SAMPLELIST="$WORKDIR/FASTQ/metadata/sample_list.txt"
OUTDIR=$WORKDIR/allignement

#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

mkdir -p $OUTDIR


#take the sample name, path to the read1 and read2 line by line 
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`


#Mapping the reads
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif \
hisat2 -x $INDEXDIR -1 $READ1 -2 $READ2 -S $OUTDIR/$SAMPLE.sam --threads 4 --rna-strandness RF --summary-file $OUTDIR/${SAMPLE}mapping_summary.txt --dta

#converting sam to bam file
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif samtools view -hbS $OUTDIR/$SAMPLE.sam > $OUTDIR/$SAMPLE.bam

#sorting the bam file
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif samtools sort -m 1000 -@ 4 -o $OUTDIR/${SAMPLE}sorted.bam -T temp $OUTDIR/$SAMPLE.bam

#indexing the bam file
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif samtools index $OUTDIR/${SAMPLE}sorted.bam