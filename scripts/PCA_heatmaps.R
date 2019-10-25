library(Seurat)
library(ggplot2)

so <- readRDS(snakemake@input[['rds']])

for (i in 1:snakemake@config[['pca.plot.dims']]){
    filename <- file.path('output','PCA_heatmaps',snakemake@wildcards[['sample']],paste0('PC_',as.character(i),'.pdf'))
    pdf(filename)
    DimHeatmap(so, dims = i, cells = 500, balanced = TRUE)
    invisible(dev.off())
}