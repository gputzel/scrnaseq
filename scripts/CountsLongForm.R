library(Seurat)
library(tidyverse)

so <- readRDS(snakemake@input[['rds']])

counts <- GetAssayData(object=so,slot="counts")
dgt <- as(counts,'dgTMatrix')
df <- cbind.data.frame(r = dgt@i + 1, c = dgt@j + 1, x = dgt@x)
genes <- factor(rownames(counts),levels=rownames(counts))
cells <- factor(colnames(counts),levels=colnames(counts))
df %>%
    mutate(gene = genes[r]) %>%
    mutate(cell = cells[c]) %>%
    mutate(counts = x) %>%
    select(cell,gene,counts) -> df.long

saveRDS(object=df.long,file=snakemake@output[['rds']])
