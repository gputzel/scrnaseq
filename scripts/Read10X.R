library(Seurat)

if("h5" %in% names(snakemake@input)){
    ss.data <- Seurat::Read10X_h5(snakemake@input[['h5']],use.names = T,unique.features = T)
}

saveRDS(ss.data,file=snakemake@output[['rds']])
