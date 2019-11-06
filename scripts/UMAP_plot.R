library(Seurat)
library(ggplot2)

so <- readRDS(snakemake@input[['rds']])

g <- DimPlot(so,reduction="umap")

ggsave(filename=snakemake@output[['pdf']],plot=g)
