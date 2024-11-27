#!/usr/bin/env bash
#SBATCH --time=00:10:00
#SBATCH --mem=100M
#SBATCH --cpus-per-task=1
#SBATCH --job-name=merging_summaries
#SBATCH --output=/data/users/vmuller/rnaseq/log/merging_summaries%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/merging_summaries%J.err
#SBATCH --partition=pibu_el8

#Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq"
MAPPINGDIR="$WORKDIR/mapping"
LOGDIR="$WORKDIR/log"
OUTFILE="$MAPPINGDIR/all_summary_mapping.txt"

#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

echo "Alignement rate summary for all sample" > $OUTFILE
for FILE in $(ls $MAPPINGDIR/*mapping_summary.txt);
do
    SAMPLE=$(basename "$FILE" | sed 's/mapping_summary.txt//')
    echo "####################################################################################################################################################################" >> $OUTFILE
    echo $SAMPLE >> $OUTFILE
    cat $FILE >> $OUTFILE
    echo "####################################################################################################################################################################" >> $OUTFILE
done