.. DEPF documentation master file, created by
   sphinx-quickstart on Wed Mar 15 15:41:25 2023.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to DEPF's documentation!
================================

**Date:** March 15, 2023. **Version:** 1.0.0

**paper:** Reliable Identification and Interpretation of Single-cell Molecular Heterogeneity and Transcriptional Regulation using Dynamic Ensemble Pruning

**Citing Us:** If you find DEPF helpful in your work or research, we would greatly appreciate citations to the following paper
::
   put the bib here

.. figure:: ../figure/DEPFframework.png
   :align: center
   :width: 5.63529in
   :height: 0.97222in


**DEPF** is constructed based on four modules (**Normalization, Hierarchical Autoencoder, Clustering Ensemble,  Dynamic Ensemble Pruning**) developed by ourselves.

- **Normalization:** The expression data are rescaled to a range of 0 to 1 for each cell.
- **Hierarchical Autoencoder:** The Normalized data are mapped to multiple low-dimensional latent spaces.
- **Clustering Ensemble:** An effective basic clustering algorithm is employed to address the non-linear embedding in the latent space to produce multiple underlying cluster results to generate cluster ensembles.
- **Dynamic Ensemble Pruning:** The low-quality basic clusterings in the ensemble are dynamically pruned away.















.. toctree::
   :maxdepth: 3
   :caption: Contents:
   
   Introduction
