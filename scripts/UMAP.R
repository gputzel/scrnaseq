library(Seurat)
library(ggplot2)

cluster.plan <- snakemake@config[['cluster_plans']][[snakemake@wildcards$plan]]

find.clusters.resolution <- cluster.plan$find.clusters.resolution
find.neighbors.k <- cluster.plan$find.neighbors.k
find.neighbors.prune.SNN <- cluster.plan$find.neighbors.prune.SNN
find.neighbors.dims <- cluster.plan$find.neighbors.dims

so <- readRDS(snakemake@input[['rds']])

so <- RunUMAP(so,dims=1:find.neighbors.dims) #Use the same number of dimensions as in neigbor-finding

saveRDS(object=so,file=snakemake@output[['rds']])
