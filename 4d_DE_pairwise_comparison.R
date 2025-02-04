######### Libraries########
if (!requireNamespace("org.Mm.eg.db", quietly = TRUE)) install.packages("org.Mm.eg.db")
if (!requireNamespace("AnnotationDbi", quietly = TRUE)) install.packages("AnnotationDbi")
if (!requireNamespace("rio", quietly = TRUE)) install.packages("rio")
if (!requireNamespace("org.Mm.eg.db", quietly = TRUE)) install.packages("org.Mm.eg.db")
if (!requireNamespace("clusterProfiler", quietly = TRUE)) BiocManager::install("clusterProfiler")

library(clusterProfiler)
library(org.Mm.eg.db)
library(org.Mm.eg.db)
library(AnnotationDbi)
library(rio)
library(grid)

#########General settings########
DATADIR = "C:\\Users\\valen\\OneDrive\\Bureau\\rna-seq\\"
setwd(DATADIR)
source("4a_DE_utils.R")

#retrieving the dds data
dds <- readRDS(DDS_FILE)

#list of the gene appearing in the reference article
genes_article <- c("Unc93b1", "Slamf7", "Ms4a6b", "Ms4a6c", "Trim30a", "Pml", 
                   "Ms4a4c", "Sp100", "Oas1g", "Mx1", "Oas3", "Zbp1", "Oas2", 
                   "Mb21d1", "Phf11d", "Dhx58", "Phf11a", "Irf9", "Lgals9", 
                   "Usp18", "Lair1", "Irf7", "Phf11b", "Xaf1", "Eif2ak2", 
                   "Rsad2", "Gm4955", "Fcgr1", "Ifit3", "Siglec1", "Aif1", 
                   "Ifit1", "Oas1a", "Oasl2", "Rtp4", "Gm5431", "Rnf213", 
                   "Ifih1", "Oasl1", "Apobec1", "Lst1", "Adap1", "Grn", 
                   "Epsti1", "Ddx60", "Apol9a", "Trim30d", "Dck")


#########Defining function########
#Perform the pairwise analysis, print number of differently expressed genes and convert result into a data frame and return it
run_pairwise_analysis <- function(contrast,comparison_name,padj_threshold=0.05){
  #Perform the comparison between the groups specified in the contrast.
  res <- results(dds, contrast = contrast)
  
  # Generate MA plot
  plotMA(res, main = paste("MA Plot -", comparison_name))
  
  #converting the result into a dataframe and adding the gene name
  result_dataframe <- add_gene_names(res)
  
  #Number of differently expressed gene
  print(comparison_name)
  num_de_genes <- sum(res$padj < padj_threshold, na.rm = TRUE)
  print(paste("Total number of differentially expressed genes:", num_de_genes))
  print(summary(res, alpha = padj_threshold))
  
  return(result_dataframe)
}


#retrieving the gene name from the ensembl ID
add_gene_names <- function(res) {
  gene_names <- mapIds(
    org.Mm.eg.db,
    keys = rownames(res),
    column = "SYMBOL",
    keytype = "ENSEMBL",
    multiVals = "first"
  )
  # Adding the column GeneName
  res <- as.data.frame(res)
  res$GeneName <- gene_names
  return(res)
}


generating_volcano_plot <- function(DE_result,comparison_name,padj_threshold=0.05,logfc_threshold=1){
  # Adding the column expression to the dataframe
  DE_result <- DE_result %>%
    mutate(
      Expression = case_when(
        log2FoldChange >= logfc_threshold & padj <= padj_threshold ~ "Up-regulated",
        log2FoldChange <= -logfc_threshold & padj <= padj_threshold ~ "Down-regulated",
        TRUE ~ "Unchanged"
      )
    )

  # Generate the volcano_plot
  volcano_plot <- ggplot(DE_result, aes(log2FoldChange, -log(pvalue, 10))) + # -log10 conversion
    geom_point(aes(color = Expression), size = 2/5) +
    xlab(expression("log"[2]*"FC")) +
    ylab(expression("-log"[10]*"P-Value")) +
    scale_color_manual(values = c("dodgerblue3", "black", "firebrick3")) +
    xlim(-10, 10) +
    ggtitle(paste("Volcano Plot -", comparison_name))
  
  print(volcano_plot)
}

# Function to print the top 10 most upregulated and downregulated genes
print_top_10_genes <- function(DE_result, comparison_name, logfc_threshold=1) {
  # Filter for genes with significant fold change (up-regulated and down-regulated)
  upregulated_genes <- DE_result[DE_result$log2FoldChange >= logfc_threshold & DE_result$padj <= 0.05, ]
  downregulated_genes <- DE_result[DE_result$log2FoldChange <= -logfc_threshold & DE_result$padj <= 0.05, ]
  
  # Get the top 10 most upregulated genes
  top_upregulated <- upregulated_genes[order(upregulated_genes$log2FoldChange, decreasing = TRUE), ]
  top_upregulated <- head(top_upregulated, 10)
  
  # Get the top 10 most downregulated genes 
  top_downregulated <- downregulated_genes[order(downregulated_genes$log2FoldChange), ]
  top_downregulated <- head(top_downregulated, 10)
  
  # Print the results
  print(paste("Top 10 upregulated genes -", comparison_name))
  print(top_upregulated[, c("GeneName", "log2FoldChange", "padj")])
  
  print(paste("Top 10 downregulated genes -", comparison_name))
  print(top_downregulated[, c("GeneName", "log2FoldChange", "padj")])
}

#GO analysis
run_go_analysis_pairwise <- function(DE_result,comparaison_name,ont,regulation="all",show_Category=10){
  
  ontology_list = list("BP"="Biological Processes","CC"="Cellular Component","MF"="Molecular Function")
  ontology = ontology_list[ont] 
  
  # Filter based on regulation type: "up", "down", or "all"
  if (regulation == "up") {
    # Upregulated genes: log2FoldChange >= 1 (1) and padj <= 0.05
    genes_de <- rownames(DE_result[DE_result$log2FoldChange >= 1 & DE_result$padj <= 0.05, ])
  } else if (regulation == "down") {
    # Downregulated genes: log2FoldChange <= -1 (1) and padj <= 0.05
    genes_de <- rownames(DE_result[DE_result$log2FoldChange <= -1 & DE_result$padj <= 0.05, ])
  } else {
    # All genes with padj <= 0.05
    genes_de <- rownames(DE_result[DE_result$padj <= 0.05 & !is.na(DE_result$padj), ])
  }
  
  # List of all genes measured in the analysis
  genes_universe <- rownames(DE_result)
  
  # Perform the GO analysis using enrichGO
  go_results <- enrichGO(
    gene = genes_de,
    universe = genes_universe,
    OrgDb = org.Mm.eg.db,
    ont = ont,
    keyType = "ENSEMBL",
    pvalueCutoff = 0.05,
    qvalueCutoff = 0.05
  )

  # Generate barplot and save the barplot in png format
  title= paste("Top 10",paste0(regulation,"regulated"),ontology,"GO","in",comparaison_name)
  
  png(paste0(title,".png"),width = 2000, height = 1600)
  bar_plot <- barplot(go_results, title = title, font.size = 28,showCategory =show_Category)+ 
    theme(
      plot.title = element_text(size = 34, face = "bold"),  
      legend.title = element_text(size = 26),               
      legend.text = element_text(size = 24)                 
    )
  grid.draw(bar_plot)
  dev.off()
  print(bar_plot)
  
  # Create a dotplot for GO terms
  dot_plot <- dotplot(go_results, title =title,font.size = 16,showCategory =show_Category)
  print(dot_plot)
}


##########################################################################################
#Pairwise analysis
#------------------------------------------------------------------------------------------------------------------------
#blood control vs case

#Differently expressed gene analysis
comparaison_name = "blood control vs case"
dataframe_blood_controlvscase <- run_pairwise_analysis(c("tissu_treatment", "Blood_WT_Case","Blood_WT_Control"),comparaison_name)
print_top_10_genes(dataframe_blood_controlvscase,comparaison_name)
generating_volcano_plot(dataframe_blood_controlvscase,comparaison_name)

#Result for the gene in the article
filter_comparison = dataframe_blood_controlvscase[dataframe_blood_controlvscase$GeneName %in% genes_article,c("log2FoldChange","pvalue","GeneName")]
print(filter_comparison)

#Go analysis
run_go_analysis_pairwise(dataframe_blood_controlvscase,comparaison_name,"BP") # Biological process
run_go_analysis_pairwise(dataframe_blood_controlvscase,comparaison_name,"MF") #Molecular function
run_go_analysis_pairwise(dataframe_blood_controlvscase,comparaison_name,"CC") #cellular componenent


#------------------------------------------------------------------------------------------------------------------------
#lung control vs case
#Differently expressed gene analysis
comparaison_name = "Lung case vs control"
dataframe_lung_controlvscase <- run_pairwise_analysis(c("tissu_treatment", "Lung_WT_Case","Lung_WT_Control"),comparaison_name)
print_top_10_genes(dataframe_lung_controlvscase,comparaison_name)
generating_volcano_plot(dataframe_lung_controlvscase,comparaison_name)

#Result for the gene in the article and print the result and save it in a excel file
dataframe_gene_article = dataframe_lung_controlvscase[dataframe_lung_controlvscase$GeneName %in% genes_article,c("log2FoldChange","pvalue","GeneName")]
print(dataframe_gene_article)
excel_file <- paste0(DATADIR,"gene_article.xlsx")
export(dataframe_gene_article, file = excel_file, rowNames = TRUE) #rownames=TRUE necessary with describe so that it prints out the headers for each row.

#GO analysis
#Biological process
run_go_analysis_pairwise(dataframe_lung_controlvscase,comparaison_name,ont="BP") 
run_go_analysis_pairwise(dataframe_lung_controlvscase,comparaison_name,ont="BP",regulation = "up") 
run_go_analysis_pairwise(dataframe_lung_controlvscase,comparaison_name,ont="BP",regulation = "down") 
#Molecular function
run_go_analysis_pairwise(dataframe_lung_controlvscase,comparaison_name,ont="MF") 
run_go_analysis_pairwise(dataframe_lung_controlvscase,comparaison_name,ont="MF",regulation = "up") 
run_go_analysis_pairwise(dataframe_lung_controlvscase,comparaison_name,ont="MF",regulation = "down") 
#Cellular componenent
run_go_analysis_pairwise(dataframe_lung_controlvscase,comparaison_name,ont="CC") 
run_go_analysis_pairwise(dataframe_lung_controlvscase,comparaison_name,ont="CC",regulation = "up") 
run_go_analysis_pairwise(dataframe_lung_controlvscase,comparaison_name,ont="CC",regulation = "down")

#----------------------------------------------------------------------------------------------------------------------
#blood vs lung case
#Differently expressed gene analysis
comparaison_name = "blood vs lung case"
dataframe_case_bloodvslung <- run_pairwise_analysis(c("tissu_treatment", "Blood_WT_Case","Lung_WT_Case"),comparaison_name)
generating_volcano_plot(dataframe_case_bloodvslung,comparaison_name)
#----------------------------------------------------------------------------------------------------------------------
#blood vs lung control
#Differently expressed gene analysis
comparaison_name = "blood vs lung control"
dataframe_control_bloodvslung <- run_pairwise_analysis(c("tissu_treatment", "Blood_WT_Control","Lung_WT_Control"),comparaison_name)
generating_volcano_plot(dataframe_control_bloodvslung,comparaison_name)


#######################################################################################
#saving the result of the pairwise comparison
#create file path, give excel file a new name
excel_file <- paste0(DATADIR,"Interactions.xlsx")

#delete previous version of the file
REM <- file.remove(excel_file) 

#export as excel, each file a-d will appear as a new sheet 
export(list(B_ca_ctrl =dataframe_blood_controlvscase , L_ca_ctrl = dataframe_lung_controlvscase, B_L_ca = dataframe_case_bloodvslung, B_L_ctrl = dataframe_control_bloodvslung), file = excel_file, rowNames = TRUE) #rownames=TRUE necessary with describe so that it prints out the headers for each row.
