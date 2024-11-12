#!/usr/bin/env bash
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500M
#SBATCH --time=00:05:10
#SBATCH --partition=pibu_el8
#SBATCH --job-name=sample_list
#SBATCH --output=/data/users/vmuller/rnaseq/log/samplelist_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/samplelist_%J.err


# Dossier source et dossier cible
source_dir="/data/courses/rnaseq_course/toxoplasma_de/reads"
target_dir="/data/users/${USER}/rnaseq/FASTQ"
LOGDIR="/data/users/${USER}/rnaseq/log"

#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

# Create the folder if it doesn't exist
mkdir -p "$target_dir"
mkdir -p "$target_dir/metadata"

# Create link for every fastq file in the source folder in the target folder
for file in "$source_dir"/*; do
    # Test if the file exist
    if [ -f "$file" ]; then
        # Take the name of the file
        file_name=$(basename "$file")
        # Create a link for the fastq file in the target directory
        ln -s "$file" "$target_dir/$file_name"
    fi
done

#Create a text file containing the name of the sample the path to the read1 and the path to the read2
for FILE in $target_dir/*_*1.fastq.gz
do 
    PREFIX="${FILE%_*.fastq.gz}"
    SAMPLE=`basename $PREFIX`
    echo -e "${SAMPLE}\t$FILE\t${FILE%?.fastq.gz}2.fastq.gz" 
done > $target_dir/metadata/sample_list.txt