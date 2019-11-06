library(Seurat)

so <- readRDDS(snakemake@input[['rds']])

all.markers <- FindAllMarkers(so,only.pos=T,min.pct=snakemake@config[['markers.min.pct']],logfc.threshold=snakemake@config[['markers.logfc.threshold']])

saveRDS(objet=all.markers,file=snakemake@output[['rds']])
