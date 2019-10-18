library(Seurat)

raw <- readRDS(snakemake@input[['rds']])

sample.name <- snakemake@wildcards[['sample']]

so <- CreateSeuratObject(counts=raw,project=sample.name,
                         min.cells=snakemake@config[['min.cells']],
                         min.features=snakemake@config[['min.features']])

saveRDS(so,file=snakemake@output[['rds']])