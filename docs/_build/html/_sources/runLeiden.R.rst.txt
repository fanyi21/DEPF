runLeiden.R
===========

.. py:function:: runLeiden(res)

    The Leiden clustering algorithm is employed to address the non-linear embedding in the latent space to produce multiple underlying cluster results to generate cluster ensemble.

    :Parameters: .. class:: res: default='1'

    :Attributes: .. class:: res: resolution

Example
-------

run **runLeiden.R**:

::

    R
    source("runLeiden.R")
    runLeiden(res=1)

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