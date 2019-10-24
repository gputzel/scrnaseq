library(Seurat)

so <- readRDS(snakemake@input[['rds']])

so[['percent.mt']] <- PercentageFeatureSet(so,pattern="^mt-")

so <- subset(so,
             subset = nFeature_RNA > snakemake@config[['min.features']] &
                 nFeature_RNA < snakemake@config[['max.features']] &
                 percent.mt < snakemake@config[['max.percent.mitochondrial']]
             )

so <- NormalizeData(so, normalization.method = snakemake@config[['normalization.method']], scale.factor = snakemake@config[['scale.factor']])

saveRDS(so,snakemake@output[['rds']])