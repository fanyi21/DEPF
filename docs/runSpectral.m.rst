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