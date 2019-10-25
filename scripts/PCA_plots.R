library(Seurat)
library(ggplot2)

so <- readRDS(snakemake@input[['rds']])

for (i in 1:(snakemake@config[['pca.plot.dims']]-1)){
    filename <- file.path('output','PCA_plots',snakemake@wildcards[['sample']],paste0('PC_',as.character(i),'_',as.character(i+1),'.pdf'))
    g <- DimPlot(so,reduction='pca',dims=c(i,i+1))
    ggsave(filename=filename,plot=g)
}