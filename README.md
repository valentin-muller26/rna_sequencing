# rna_sequencing

## Table of Contents
- [About the project](#about-the-project)
  - [List of sample](#list-of-sample)
- [Overview of the workflow](#overview-of-the-workflow)
  - [0. Getting started](#0-getting-started)
  - [1. Quality control](#1-quality-control)
  - [2. Map reads to the reference genome](#2-map-reads-to-the-reference-genome)
  
## About the project

### list of sample 
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

the mapping stage is carried out in 3 main steps
- Recover reference genome (Mus_musculus.GRCm39.dna.primary_assembly.fa) and annotation (Mus_musculus.GRCm39.113.gtf) from Ensemble
- Mapping to the reference genome
- Processing the sam file


## 3. Count the number of reads per gene
