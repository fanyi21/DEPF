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