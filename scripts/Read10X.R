library(Seurat)

if("h5" %in% names(snakemake@input)){
    ss.data <- Seurat::Read10X_h5(snakemake@input[['h5']],use.names = T,unique.features = T)
}

if(all(c('barcodes','genes','matrix') %in% names(snakemake@input))){
    ss.data <- Seurat::Read10X(data.dir=paste0("output/10X_uncompressed/",snakemake@wildcards[['sample']]),gene.column=1)
}

saveRDS(ss.data,file=snakemake@output[['rds']])
