library(Seurat)
library(ggplot2)

so <- readRDS(snakemake@input[['rds']])

g <- FeaturePlot(so, features = snakemake@config[["genes_of_interest"]])

ggsave(filename=snakemake@output[['pdf']],plot = g,width=10,height=10)
