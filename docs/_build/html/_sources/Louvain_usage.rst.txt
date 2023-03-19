Louvain usage workflow
=======================

example data:
::

    # a raw scRNA-seq data, goolam.rds, has been stored in the ./scRNAsqData.
    # https://hemberg-lab.github.io/scRNA.seq.datasets/mouse/edev/#goolam
    da <- readRDS("./scRNAseqData/goolam.rds")
    da

output:
::

    class: SingleCellExperiment 
    dim: 41428 124 
    metadata(0):
    assays(2): counts logcounts
    rownames(41428): ENSMUSG00000000001 ENSMUSG00000000003 ... ERCC-00170 ERCC-00171
    rowData names(19): is_feature_control is_feature_control_ERCC ... feature_symbol feature_id
    colnames(124): X2cell_1_A X2cell_1_B ... ME_4cell_6_C ME_4cell_6_D
    colData names(31): cell_type1 total_features ... pct_counts_top_50_features_ERCC is_cell_control
    reducedDimNames(0):
    mainExpName: NULL
    altExpNames(0)

**Step 1**: Normalizing and mapping the raw scRNA-seq data to multiple low-dimensional latent spaces. A **9_latent_data** folder is produced and saved in the ***./OutputData***.

::

    # activate the environment       
    conda activate DEPF 
    cd DEPF/HierarchicalAutoencoder/
    Rscript runHA.R

output:

::

    [1] "goolam.rds"
    output 9 of  1  latent:  goolam .
    output 9 of  2  latent:  goolam .
    output 9 of  3  latent:  goolam .
    output 9 of  4  latent:  goolam .
    output 9 of  5  latent:  goolam .
    output 9 of  6  latent:  goolam .
    output 9 of  7  latent:  goolam .
    output 9 of  8  latent:  goolam .
    output 9 of  9  latent:  goolam .


**Step 2**: Selecting **Louvain** to generate a clustering ensemble.
::

    R
    source("runLouvain.R")
    runLouvain(res=1, ensemble_num = 10)

output:

::

    ********************************************** .
    output 9 of  1  latent:  goolam .
    ********************************************** .
    ---------------------------------------------- .
    resolution:  1 .
    ---------------------------------------------- .
    Computing nearest neighbor graph
    Computing SNN
    [1] "============  Louvain   ============"
    Modularity Optimizer version 1.3.0 by Ludo Waltman and Nees Jan van Eck

    Number of nodes: 124
    Number of edges: 4005

    Running Louvain algorithm...
    0%   10   20   30   40   50   60   70   80   90   100%
    ----|----|----|----|----|----|----|----|----|----|
    **************************************************|
    Maximum modularity in 10 random starts: 0.4066
    Number of communities: 4
    Elapsed time: 0 seconds

    ...
    ...
    ...
    ********************************************** .
    output 9 of  9  latent:  goolam .
    ********************************************** .
    ---------------------------------------------- .
    resolution:  1 .
    ---------------------------------------------- .
    Computing nearest neighbor graph
    Computing SNN
    [1] "============  Louvain   ============"
    Modularity Optimizer version 1.3.0 by Ludo Waltman and Nees Jan van Eck

    Number of nodes: 124
    Number of edges: 4005

    Running Louvain algorithm...
    0%   10   20   30   40   50   60   70   80   90   100%
    ----|----|----|----|----|----|----|----|----|----|
    **************************************************|
    Maximum modularity in 10 random starts: 0.4066
    Number of communities: 4
    Elapsed time: 0 seconds


The **Louvain_resolution_1.csv** is produced and saved in the **./OutputData**.

**Step 3**: Performing dynamic ensemble pruning. The **final_clustering.csv** is produced and saved in the **./OutputData**.

::

    runBioFOA("Louvain", 5, 1)


output:

::

    ==========run Ensemble Pruning.==================
    goolam
    Starting parallel pool (parpool) using the 'local' profile ...
    Connected to the parallel pool (number of workers: 12).
    ===========load Louvain ensemble=================
    =========  NMI  ==========
        0.7900

    =========  ARI  ==========
        0.6400