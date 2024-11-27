#!/usr/bin/env bash
#SBATCH --time=00:10:00
#SBATCH --mem=10M
#SBATCH --cpus-per-task=1
#SBATCH --job-name=get_reference
#SBATCH --output=/data/users/vmuller/rnaseq/log/get_reference_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/get_reference_%J.err
#SBATCH --partition=pibu_el8


#Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq"
REFGENDIR="$WORKDIR/reference_genome"
LOGDIR="$WORKDIR/log"
REFGENOMEFILE="Mus_musculus.GRCm39.dna.primary_assembly.fa.gz"
ANNOTATIONFILE=Mus_musculus.GRCm39.113.gtf.gz
#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

#Create the directory where the reference genome and the annotation will be downloaded
mkdir -p $REFGENDIR

#move to the folder for the reference genome and download the fa and gtf file from ensembl
cd $REFGENDIR
wget https://ftp.ensembl.org/pub/release-113/fasta/mus_musculus/dna/$REFGENOMEFILE
wget https://ftp.ensembl.org/pub/release-113/gtf/mus_musculus/$ANNOTATIONFILE



#Doing the checksum for the file to be sure that they were no error during the downloading
echo "Checksum for fasta file"
sum $REFGENDIR/$REFGENOMEFILE
echo "Checksum for gtf file"
sum $REFGENDIR/$ANNOTATIONFILE


#unzip the reference genome for later step
gunzip $REFGENDIR/$REFGENOMEFILE

#unzip the annotation file for later step
gunzip $REFGENDIR/$ANNOTATIONFILE
