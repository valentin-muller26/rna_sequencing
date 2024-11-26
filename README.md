# rna_sequencing

## Table of Contents
- [About the project](#about-the-project)
  - [List of sample](#list-of-sample)
- [Overview of the workflow](#overview-of-the-workflow)
  - [0. Getting started](#0-getting-started)
  - [1. Quality control](#1-quality-control)
  - [2. Map reads to the reference genome](#2-map-reads-to-the-reference-genome)
  
## About the project
The following workflow is part of a project that examine how *Toxoplasma gondii* infection impact the expression of gene in mouse blood and lung tissues. The goal of this project is to identify genes differentially expressed between the different tissues and treatment and find GO terms enriched in these genes.

The dataset utilized for this project come from the study by [Singhania et al. (2019)](https://www.nature.com/articles/s41467-019-10601-6). The data consist of 3 biological replicates for the control samples and 5 replicates of the *Toxoplasma* infected mices (Case). ... [Table 1](#List of sample)
Libraries were constructed using a strand-specific protocol and sequenced in high-resolution paired-end mode with the Illumina HiSeq 4000 platform

### List of sample 
|Sample	|Group|
|-------|------|
|SRR7821921|	Lung_WT_Case|
SRR7821922|	Lung_WT_Case
SRR7821918	|Lung_WT_Case
SRR7821919	|Lung_WT_Case
SRR7821920|	Lung_WT_Case
SRR7821937	|Lung_WT_Control
SRR7821938	|Lung_WT_Control
SRR7821939	|Lung_WT_Control
SRR7821949	|Blood_WT_Case
SRR7821950	|Blood_WT_Case
SRR7821951	|Blood_WT_Case
SRR7821952	|Blood_WT_Case
SRR7821953	|Blood_WT_Case
SRR7821968	|Blood_WT_Control
SRR7821969	|Blood_WT_Control
SRR7821970|	Blood_WT_Control

*Table 1: List of samples. The "Sample" column corresponds to the names of the FASTQ files. The "Case" group includes infected mice, while the "Control" group represents non-infected mice.*
## Overview of the workflow

## 0. getting started

This step consist of the script named 0_get_samplelist used for organizing and ... This script create a FASTQ directory where links to all FASTQ files are created. Additionally, it creates a metadata folder containing the sample_list file. This file lists the name of each sample along with the corresponding paths to the Read1 and Read 2 FASTQ files.

## 1. Quality control 

The Quality control step involves two script :
- 1_FASTQC : Generate individual quality control report for each sample
- 2_MultiQC : Combines all the indvidual report in a single file, facilitating the assessment of data quality across all samples.

## 2. Map reads to the reference genome

the mapping step is carried out by the following script
- 3_get_reference :Download reference genome (Mus_musculus.GRCm39.dna.primary_assembly.fa) and annotation (Mus_musculus.GRCm39.113.gtf) from Ensembl
- 4_hisat_index : Generate index of the reference for the mapping step
- 5_hisat_mapping : Maps the reads to the reference genome
- 6_samtools_conversion_bam: Convert the sam files generated during the last step to a bam file


## 3. Count the number of reads per gene

This step uses the script 9_featurecount that produce a table of counts containing the number of reads per gene in each sample and a summary file. 
