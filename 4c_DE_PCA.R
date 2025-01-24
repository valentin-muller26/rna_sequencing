######### Libraries########
if (!requireNamespace("pheatmap", quietly = TRUE)) install.packages("pheatmap")
if (!requireNamespace("RColorBrewer", quietly = TRUE)) install.packages("RColorBrewer")
library(pheatmap)
library(RColorBrewer)

#########General settings########
DATADIR = "C:\\Users\\valen\\OneDrive\\Bureau\\rna-seq\\"
setwd(DATADIR)
source("4a_DE_utils.R")

#Retrieving the dds data
dds <- readRDS(DDS_FILE)

# Rename for the legend of the PCAplot
colData(dds)$tissu_treatment <- factor(colData(dds)$tissu_treatment, 
                                       levels = c("Blood_WT_Case", "Blood_WT_Control", 
                                                  "Lung_WT_Case", "Lung_WT_Control"),
                                       labels = c("Blood Case", "Blood Control", 
                                                  "Lung Case", "Lung Control"))
sample_info <- read.table("sample_info.txt")
#Removing the dependence of the variance on the mean
result_vst_DESeq <- vst(dds, blind = TRUE)


###############################################################################
# Generating the PCA
plotPCA(result_vst_DESeq, intgroup = "tissu_treatment")

# Generating the  heatmap
sampleDists <- dist(t(assay(result_vst_DESeq)))
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(sample_info$sample,sample_info$tissu_treatment, sep = "_")
colnames(sampleDistMatrix) <- rownames(sampleDistMatrix)
colors <- colorRampPalette(rev(brewer.pal(9, "Blues")))(255)
pheatmap(
  sampleDistMatrix,
  clustering_distance_rows = sampleDists,
  clustering_distance_cols = sampleDists,
  col = colors,
  main = "Heatmap distances between samples"
)

