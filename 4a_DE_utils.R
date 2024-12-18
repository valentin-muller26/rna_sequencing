######### Libraries########
# General Libraries used in all scripts

# Install required packages if not already installed
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!requireNamespace("DESeq2", quietly = TRUE)) BiocManager::install("DESeq2")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2") 
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("gridExtra") 


#loading the library
library(DESeq2)
library(stringr)
library(dplyr)
library(ggplot2)

########Constant##########
#Defining the path and the name of the file
DATADIR = "C:\\Users\\valen\\OneDrive\\Bureau\\rna-seq\\"
FEATURECOUNTFILE = "gene_count.txt"
SAMPLELISTFILE = "tablesample.txt"
DDS_FILE <- "dds.rds"
