#!/usr/bin/env bash
#SBATCH --time=00:10:00
#SBATCH --mem=10M
#SBATCH --cpus-per-task=1
#SBATCH --job-name=get_reference
#SBATCH --output=/data/users/vmuller/rnaseq/log/get_reference_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/get_reference_%J.err
#SBATCH --partition=pibu_el8

#Define variable
WORKDIR="/data/users/${USER}/rnaseq/"
REFGENDIR="$WORKDIR/reference_genome"
LOGDIR="$WORKDIR/log"

#Create the directory for the error and output file if not present
mkdir -p $LOGDIR
mkdir -p $REFGENDIR

#move to the folder for the reference genome and download the fa and gff file from ensembl
cd $REFGENDIR
wget https://ftp.ensembl.org/pub/release-113/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
wget https://ftp.ensembl.org/pub/release-113/gtf/mus_musculus/Mus_musculus.GRCm39.113.gtf.gz

