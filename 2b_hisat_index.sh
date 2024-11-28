#!/usr/bin/env bash
#SBATCH --time=03:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=hisat_index
#SBATCH --output=/data/users/vmuller/rnaseq/log/hisat_index_%J.out
#SBATCH --error=/data/users/vmuller/rnaseq/log/hisat_index_%J.err
#SBATCH --partition=pibu_el8

#Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq"
REFGENDIR="$WORKDIR/reference_genome"
LOGDIR="$WORKDIR/log"
INDEXDIR="$WORKDIR/index_hisat"
REFGENOMEFILE="Mus_musculus.GRCm39.dna.primary_assembly.fa"


#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

#Create the output directory
mkdir -p $INDEXDIR

#Use hisat to create the index the parameter $REFGENDIR/$REFGENOMEFILE correspond to the genome file and $INDEXDIR/genome_index to the path and name of the resulting index file
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif hisat2-build $REFGENDIR/$REFGENOMEFILE $INDEXDIR/genome_index