#########General settings########
DATADIR = "C:\\Users\\valen\\OneDrive\\Bureau\\rna-seq\\"
setwd(DATADIR)
source("4a_DE_utils.R")

###########################################################################
# Retrieving the data and processing 
featurecountdata <- read.table(FEATURECOUNTFILE, header = TRUE, row.names = 1)
sample_list <- read.table(SAMPLELISTFILE, header = TRUE)

# processing the count data
counts = featurecountdata[,6:ncol(featurecountdata)]
sample_name <- str_extract(colnames(counts), "SRR\\d+")
colnames(counts) <- sample_name

# Retrieve tissu_treatment to be sure that they are in the right order
sample_name = data_frame(Sample=sample_name)
group_treatment <- left_join(sample_name, 
                             sample_list, 
                             by = "Sample")$Group

# Prepare sample info
sample_info <- data.frame(
  sample  =colnames(counts),
  tissu_treatment =  as.factor(group_treatment)
)
write.table(sample_info,"sample_info.txt")
############################################################################################################
# DESEQ analysis
dds <- DESeqDataSetFromMatrix(countData = counts, 
                              colData = sample_info, 
                              design = ~ tissu_treatment)
dds <- DESeq(dds)

#saving the result of the DESeq analysis for further analysis
saveRDS(dds, DDS_FILE)