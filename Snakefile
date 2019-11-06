configfile: "config.json"

rule list_samples:
    run:
        for sample in config['samples'].keys():
            print(sample)

def uncompress_input(wildcards):
    d={
        "barcodes":config['samples'][wildcards.sample]['barcodes'],
        "genes":config['samples'][wildcards.sample]['genes'],
        "matrix":config['samples'][wildcards.sample]['matrix']
      }
    return d

rule uncompress:
    input:
        unpack(uncompress_input)
    output:
        barcodes=temp("output/10X_uncompressed/{sample}/barcodes.tsv"),
        genes=temp("output/10X_uncompressed/{sample}/genes.tsv"),
        matrix=temp("output/10X_uncompressed/{sample}/matrix.mtx")
    run:
        shell('gzcat {input.barcodes} > {output.barcodes}')
        shell('gzcat {input.genes} > {output.genes}')
        shell('gzcat {input.matrix} > {output.matrix}')

def read_10X_input(wildcards):
    sample = wildcards.sample
    d = {}
    sample_config = config["samples"][sample]
    if "h5_path" in sample_config.keys():
        d["h5"] = sample_config["h5_path"]
    return d

rule read_10X:
    input:
        unpack(read_10X_input)
    output:
        rds="output/RData/Read10X/{sample}.rds"
    script:
        "scripts/Read10X.R"

rule overview:
    input:
        rds="output/RData/SeuratObject/{sample}.rds"
    output:
        "output/Overview/{sample}.html"
    script:
        "scripts/Overview.Rmd"

rule CreateSeuratObject:
    input:
        rds="output/RData/Read10X/{sample}.rds"
    output:
        rds="output/RData/SeuratObject/{sample}.rds"
    script:
        "scripts/CreateSeuratObject.R"

rule CountsLongForm:
    input:
       rds="output/RData/SeuratObject/{sample}.rds"
    output:
       rds="output/RData/CountsLongForm/{sample}.rds"
    script:
        "scripts/CountsLongForm.R" 

rule PercentMitochondrial:
    input:
        rds="output/RData/SeuratObject/{sample}.rds"
    output:
        "output/PercentMitochondrial/{sample}.html"
    script:
        "scripts/mitochondrial.Rmd"

rule FilterNormalize:
    input:
        rds="output/RData/SeuratObject/{sample}.rds"
    output:
        rds="output/RData/FilterNormalize/{sample}.rds"
    script:
        "scripts/FilterNormalize.R"

rule VariableFeaturesAndPCA:
    input:
        rds="output/RData/FilterNormalize/{sample}.rds"
    output:
        rds="output/RData/PCA/{sample}.rds"
    script:
        "scripts/PCA.R"

rule VariableGenesHTML:
    input:
        rds="output/RData/PCA/{sample}.rds"
    output:
        "output/VariableGenes/{sample}.html"
    script:
        "scripts/VariableGenes.Rmd"

rule PCLoadings:
    input:
        rds="output/RData/PCA/{sample}.rds"
    output:
        "output/PC_loadings/{sample}.html"
    script:
        "scripts/PC_loadings.Rmd"

rule JackStraw:
    input:
        rds="output/RData/PCA/{sample}.rds"
    output:
        "output/JackStraw_Plots/{sample}.html"
    script:
        "scripts/JackStraw.Rmd"

rule ElbowPlot:
    input:
        rds="output/RData/PCA/{sample}.rds"
    output:
        "output/ElbowPlots/{sample}.html"
    script:
        "scripts/ElbowPlot.Rmd"

rule Cluster:
    input:
        rds="output/RData/PCA/{sample}.rds"
    output:
        rds="output/RData/Cluster/{sample}/{plan}.rds"
    script:
        "scripts/cluster.R"

rule PCA_plots:
    input:
        rds="output/RData/PCA/{sample}.rds"
    output:
        ["output/PCA_plots/{sample}/PC_" + str(i) + "_" + str(i+1) + ".pdf" for i in range(1,config["pca.plot.dims"])]
    script:
        "scripts/PCA_plots.R"

rule PCA_heatmaps:
    input:
        rds="output/RData/PCA/{sample}.rds"
    output:
        ["output/PCA_heatmaps/{sample}/PC_" + str(i) + ".pdf" for i in range(1,config["pca.plot.dims"] + 1)]
    script:
        "scripts/PCA_heatmaps.R"

rule UMAP:
    input:
        rds="output/RData/Cluster/{sample}/{plan}.rds"
    output:
        pdf="output/UMAP/{sample}/{plan}.pdf"
    script:
        "scripts/UMAP.R"

rule violin:
    input:
        rds="output/RData/Cluster/{sample}/{plan}.rds"
    output:
        pdf="output/ViolinPlots/{sample}/{plan}.pdf"
    script:
        "scripts/ViolinPlot.R"
