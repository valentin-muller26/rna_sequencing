# rna_sequencing

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
## Overview of the workflow

## 0. getting started

This step consist of the script named 0_get_samplelist used for organizing and ... This script create a FASTQ directory where links to all FASTQ files are created. Additionally, it creates a metadata folder containing the sample_list file. This file lists the name of each sample along with the corresponding paths to the Read1 and Read 2 FASTQ files.

## 1. Quality control 

The Quality control step consist of the script 1_FASTQC that generate individual quality control report for each sample and the 2_MultiQC script that combines all the report together in a single file, facilitating the assessment of data quality across all samples.

## 2. Map reads to the reference genome



## 3. Count the number of reads per gene
