# RNA sequencing

## Table of Contents
- [About the project](#about-the-project)
  - [List of sample](#list-of-sample)
- [Overview of the workflow](#overview-of-the-workflow)
  - [0. Getting started](#0-getting-started)
  - [1. Quality control](#1-quality-control)
  - [2. Map reads to the reference genome](#2-map-reads-to-the-reference-genome)
  - [3. Count the number of reads per gene](#3-Count-the-number-of-reads-per-gene)
  
## About the project

The following workflow is part of a project that examine how *Toxoplasma gondii* infection impact the expression of gene in mouse blood and lung tissues. The goal of this project is to identify genes differentially expressed between the different tissues and treatment and find GO terms enriched in these genes.

The dataset utilized for this project come from the study by [Singhania et al. (2019)](https://www.nature.com/articles/s41467-019-10601-6) and can be found in Gene Expression Omnibus (GEO), accession GSE119855. The data consist of 3 biological replicates for the control samples and 5 replicates of the *Toxoplasma* infected mices (Case) in both lung and blood tissues ([Table 1](#list-of-samples)).
Libraries were constructed using a strand-specific protocol and sequenced in high-resolution paired-end mode with the Illumina HiSeq 4000 platform

### List of sample 
*Table 1: List of samples. The "Sample" column corresponds to the names of the FASTQ files. The "Case" group includes infected mice, while the "Control" group represents non-infected mice.*

|Sample	|Group|
|-------|------|
|SRR7821921|	Lung Case|
SRR7821922|	Lung Case
SRR7821918	|Lung Case
SRR7821919	|Lung Case
SRR7821920|	Lung Case
SRR7821937	|Lung Control
SRR7821938	|Lung Control
SRR7821939	|Lung Control
SRR7821949	|Blood Case
SRR7821950	|Blood Case
SRR7821951	|Blood Case
SRR7821952	|Blood Case
SRR7821953	|Blood Case
SRR7821968	|Blood Control
SRR7821969	|Blood Control
SRR7821970|	Blood Control

## Overview of the workflow

## 0. Getting started

This step consists of the script named 0_get_samplelist used for organizing and generating the file containing the list of the samples essential for the rest of the workflow. This script creates a FASTQ directory where links to all FASTQ files are created. Additionally, it makes a metadata folder containing the sample_list file. This file lists the name of each sample along with the corresponding paths to the Mate 1 and Mate 2 FASTQ files and also creates a file that recovers the table of the README file containing the names of all samples and their corresponding group.

## 1. Quality control 

The Quality control step involves two script :
- 1a_FASTQC : Generate individual quality control report for each sample
- 1b_MultiQC : Combines all the indvidual report in a single file, facilitating the assessment of data quality across all samples.

## 2. Map reads to the reference genome

the mapping step is carried out by the following scripts :
- 2a_get_reference :Download reference genome (Mus_musculus.GRCm39.dna.primary_assembly.fa) and annotation (Mus_musculus.GRCm39.113.gtf) from Ensembl
- 2b_hisat_index : Generate index of the reference genome using the tools hisat 
- 2c_hisat_mapping : Maps the reads to the reference genome using hisat and the following parameter :
    - -1 : path to the first mate
    - -2 : path to the second mate
    - -S : path to output file 
    - --threads : number of threads use by hisat
    - --rna-strandness RF :  specify that the first read is the reverse strand
    - --summary-file : allow to create a summary file containing statistic about the mapping
- 2d_merging_summary_mapping : (Optional) Combine all the summary file generated during the mapping in one file
- 2e_samtools_conversion_bam: Convert the sam files generated during the last step to a bam file
- 2f_samtools_sort : Sort the bam files
- 3g samtools_index : index the bam files

## 3. Count the number of reads per gene

This step uses the script 3_featurecount that use the tools featurecount version v2.0.1 to produce a table of counts containing the number of reads per gene in each sample and a summary file. 
The featurecount tools use the following parameter :
- -T : number of thread used by featurecount
- -p : specify that the reads were sequenced pair-end
- -s2 : specify that the first read is the reverse strand
- -Q10 : only consider the align read with a quality equal or higher than 10
- -t exon : specifies that feature should count reads based on the exon feature type in the input annotation file
- -g gene_id : specifies which attribute in the annotation file should be used to group exons into genes for counting.
- -a : path to the annotation file
- -o : path and name of the outputfile

## 4 Exploratory data analysis

DEseq2
