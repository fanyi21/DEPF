runLeiden.R
===========

.. py:function:: runLeiden(res, ensemble_num)

    The Leiden clustering algorithm is employed to address the non-linear embedding in the latent space to produce multiple underlying cluster results to generate cluster ensemble.

    :Parameters 1: .. class:: res: default='1'

    :Attributes 1: .. class:: res: resolution

    :Parameters 2: .. class:: ensemble_num: default='10'

    :Attributes 2: .. class:: ensemble_num: number of basic clusterings

Example
-------

run **runLeiden.R**:

::

    R
    source("runLeiden.R")
    runLeiden(res=1, ensemble_num = 10)

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
    [1] "============  Leiden   ============"
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
    [1] "============  Leiden   ============"

The **Leiden_resolution_1.csv** is produced and saved in the **./OutputData**.