runBioFOA.m 
===========

.. py:function:: runBioFOA(algorithm_name,cluster_K, res)

    Performing dynamic ensemble pruning.

    :Parameters 1: .. class:: algorithm_name: "Louvain", "Leiden", "spectral"

    :Attributes 1: .. class:: algorithm_name: name of basic clustering algorithm

    :Parameters 2: .. class:: cluster_K: int 

    :Attributes 2: .. class:: cluster_K: number of clusters same as spectral clustering algorithm

    :Parameters 3: .. class:: res: float 

    :Attributes 3: .. class:: res: resolution same as Louvain or Leiden clustering algorithm

Example
-------
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

run **runHA.R**:

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

A **9_latent_data** folder is produced and saved in the **./OutputData**.

run **runSpectral.m**:
::

    cd BiobjectiveFruitFlyOptimizationAlgorithm/ 
    matlab
    runSpectral(10,10)

output:

::

    ==========run spectral clustering.==================
    10

    goolam
    Starting parallel pool (parpool) using the 'local' profile Connected to the parallel pool (number of workers: 12).

The **spectral_cluster_K_5.csv** is produced and saved in the **./OutputData**.

run **runBioFOA.m**

::

    runBioFOA("spectral", 5, 1)


output:

::

    ==========run Ensemble Pruning.==================
    goolam
    ==========load spectral ensemble=================
    =========  NMI  ==========
    0.8900
    =========  ARI  ==========
    0.9100

The **final_clustering.csv** is produced and saved in the **./OutputData**.