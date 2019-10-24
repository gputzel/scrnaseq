library(Seurat)

so <- readRDS(snakemake@input[['rds']])

so <- FindVariableFeatures(so,
                           selection.method=snakemake@config[['variable.selection.method']],
                           nfeatures=snakemake@config[['num.variable.features']]
                          )

so <- ScaleData(so,features=rownames(so))

so <- RunPCA(so,features=VariableFeatures(so))

saveRDS(so,snakemake@output[['rds']])