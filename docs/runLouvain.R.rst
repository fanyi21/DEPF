runLouvain.R
=============

.. py:function:: runLouvain(res)

    The Louvain clustering algorithm is employed to address the non-linear embedding in the latent space to produce multiple underlying cluster results to generate cluster ensemble.

    :Parameters: .. class:: res: default='1'

    :Attributes: .. class:: res: resolution

Example
-------

run **runLouvain.R**:

::

    R
    source("runLouvain.R")
    runLouvain(res=1)

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