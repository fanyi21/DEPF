.. DEPF documentation master file, created by
   sphinx-quickstart on Wed Mar 15 15:41:25 2023.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to DEPF's documentation!
================================

**Date:** March 15, 2023. **Version:** 1.0.0

**Contact:** Thank you for using DEPF! Any questions, suggestions or advices are welcome.
Email address: fanyi21@mails.jlu.edu.cn, lixt314@jlu.edu.cn.

**paper:** Reliable Identification and Interpretation of Single-cell Molecular Heterogeneity and Transcriptional Regulation using Dynamic Ensemble Pruning

**Overview:**

.. figure:: ./figure/DEPFframework.png
   :align: center
   :alt: DEPF framework

**DEPF** is constructed based on four modules (**Normalization, Hierarchical Autoencoder, Clustering Ensemble,  Dynamic Ensemble Pruning**) developed by ourselves.

- **Normalization:** The expression data are rescaled to a range of 0 to 1 for each cell.
- **Hierarchical Autoencoder:** The normalized data are mapped to multiple low-dimensional latent spaces.
- **Clustering Ensemble:** An effective basic clustering algorithm is employed to address the non-linear embedding in the latent space to produce multiple underlying cluster results to generate cluster ensemble.
- **Dynamic Ensemble Pruning:** The low-quality basic clusterings in the ensemble are dynamically pruned away.

.. toctree::
   :maxdepth: 2
   :caption: Getting Started
   
   ./Description.rst
   ./Installation.rst

.. toctree::
   :maxdepth: 2
   :caption: API

   ./runHA.R.rst
   ./runLouvain.R.rst
   ./runLeiden.R.rst
   ./runSpectral.m.rst
   ./runBioFOA.m.rst

.. toctree::
   :maxdepth: 2
   :caption: Examples