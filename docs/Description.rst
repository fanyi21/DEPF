Description
===========

The DEPF package contains four files: **./scRNAseqdata**, **./HierarchicalAutoencoder**, **./BiobjectiveFruitFlyOptimizationAlgorithm**, and **./OutputData**.

- **./scRNAseqdata:** Storing raw scRNA-seq data sets

- **./HierarchicalAutoencoder:** Storing *Normalization module*, *Hierarchical Autoencoder module*, *Louvain clustering module*, *Leiden clustering module*.

- **./BiobjectiveFruitFlyOptimizationAlgorithm:** Storing *Spectral clusteirng module*, *dynamic ensemble pruning mudule*.

- **./OutputData:** Storing latent data, Louvain clustering results, Leiden clustering results, final clustering results, etc.

The operational process of DEPF involves three parts: **RunHA.R**, **runLouvain.R || runLeiden.R || runSpectral.m**, and **runBioFOA.m**.

- **RunHA.R:** Normalizing and mapping the raw -scRNA-seq data yo a low-dimensional latent space.

- **runLouvain.R || runLeiden.R || runSpectral.m:** Selecting a basic clustering algorithm to generate a clustering ensemble.

- **runBioFOA.m:** Performing dynamic ensemble pruning.

.. figure:: ./figure/ModularityOfDEPF.png
   :align: center
   :alt: DEPF framework