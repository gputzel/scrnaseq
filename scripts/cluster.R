library(Seurat)

sample.name <- snakemake@wildcards$sample
cluster.plan <- snakemake@config[['cluster_plans']][[snakemake@wildcards$plan]]

find.clusters.resolution <- cluster.plan$find.clusters.resolution
find.neighbors.k <- cluster.plan$find.neighbors.k
find.neighbors.prune.SNN <- cluster.plan$find.neighbors.prune.SNN
find.neighbors.dims <- cluster.plan$find.neighbors.dims

so <- readRDS(snakemake@input[['rds']])

so <- FindNeighbors(so,dims=find.neighbors.dims,
                    k.param = find.neighbors.k,
                    prune.SNN = find.neighbors.prune.SNN
                )

so <- FindClusters(so,
                   modularity.fxn = 1,
                   resolution = find.clusters.resolution,
                   algorithm = 1,
                   n.start = 10,
                   n.iter=10,
                   random.seed = 0
                  )

saveRDS(so,file=snakemake@output[['rds']])