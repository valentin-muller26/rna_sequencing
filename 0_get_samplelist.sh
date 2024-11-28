#!/usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500M
#SBATCH --time=00:05:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=sample_list
#SBATCH --output=/data/users/vmuller/rnaseq/log/samplelist_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/samplelist_%J.err


#Setting the constant for the directories
WORKDIR="/data/users/${USER}/rnaseq/"
READSDIR="/data/courses/rnaseq_course/toxoplasma_de/reads"
OUTDIR="$WORKDIR/FASTQ"
LOGDIR="$WORKDIR/log"
METADATADIR="$OUTDIR/metadata"

#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

# Create the folder if it doesn't exist
mkdir -p $OUTDIR
mkdir -p $METADATADIR

# Create link for every fastq file in the source folder in the target folder
for file in "$READSDIR"/*.fastq.gz; do
        FILENAME=$(basename "$FILE")
        ln -s "$FILE" "$OUTDIR/$FILENAME"
done

#Create a text file containing the name of the sample the path to the read1 and the path to the read2
for FILE in $OUTDIR/*_*1.fastq.gz
do 
    PREFIX="${FILE%_*.fastq.gz}"
    SAMPLE=`basename $PREFIX`
    echo -e "${SAMPLE}\t$FILE\t${FILE%?.fastq.gz}2.fastq.gz" 
done > $METADATADIR/sample_list.txt

#Copy the README FILE and recover only the table for the sample
cp $READSDIR/README $OUTDIR
tail -n +9 $OUTDIR/README > $OUTDIR/tablesample.txt