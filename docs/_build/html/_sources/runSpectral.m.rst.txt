runSpectral.m 
=============

.. py:function:: runSpectral(cluster_K, ensemble_num)

    The Spectral clustering algorithm is employed to address the non-linear embedding in the latent space to produce multiple underlying cluster results to generate cluster ensemble.

    :Parameters 1: .. class:: cluster_K: default='10'

    :Attributes 1: .. class:: cluster_K: number of clusters

    :Parameters 2: .. class:: ensemble_num: default='10'

    :Attributes 2: .. class:: ensemble_num: number of basic clusterings

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