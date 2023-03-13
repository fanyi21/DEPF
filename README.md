# DEPF: Reliable Identification and Interpretation of Single-cell Molecular Heterogeneity and Transcriptional Regulation using Dynamic Ensemble Pruning

Unsupervised clustering is an essential step in identifying cell types from single-cell RNA sequencing (scRNA-seq) data. However, a common issue with unsupervised clustering models is that the optimization direction of the objective function and the final generated clustering labels in the absence of supervised information may be inconsistent or even arbitrary. To address this challenge, a dynamic ensemble pruning framework is proposed to identify and interpret single-cell molecular heterogeneity. In particular, a silhouette coefficient-based indicator is developed and evaluated to determine the optimization direction of the bi-objective function. In addition, a hierarchical autoencoder is employed to project the high-dimensional scRNA-seq data onto multiple low-dimensional latent space sets, and then a clustering ensemble is produced in the latent space by the basic clustering algorithm. Following that, a bi-objective fruit fly optimization algorithm is designed to prune dynamically the low-quality basic clustering in the ensemble. Multiple experiments are conducted on 28 real scRNA-seq datasets and one large real scRNA-seq dataset from diverse platforms and species to validate the effectiveness of the dynamic ensemble pruning framework. In addition, biological interpretability and transcriptional and post-transcriptional regulatory are conducted to explore biological patterns from the cell types identified, which could provide novel insights into characterizing the mechanisms.


## DATA AVAILABILITY
The unsupervised dimensionality reduction is implemented in R.
The basic clustering algorithm, objective function, dynamic ensemble pruning are implemented in MATLAB. 
### R enviroment
1. R 4.1.1

2. Rstudio (optional)

3. [scDHA](https://github.com/duct317/scDHA)

5. R.matlab

7. SingleCellExperiment

### MATLAB enviroment
 1. MATLAB 2019b 


## How to run (for example: Windows operating system)

1. Download the file: ***DEPF***.

2. Open the file  ***DEPF/Hierarchical autoencoder*** in Rstudio by double-clicking ***DEPF/Hierarchical autoencoder/Hierarchical autoencoder.Rproj***.

3. Run the code ```devtools::load_all(".")``` in Console.

4. Run the file ***./main.R***.

    > In particular, an example of scRNA-seq data is ***pollen.rds*** provided in ***DEPF/scRNAseqData***.
    
    > The 28 real scRNA-seq datasets and one large-scale real scRNA-seq dataset are describled in METHODS of paper.

5. Output the file ***DEPF/9_latent_data***.

6. Open the file ***DEPF/bi-objective fruit fly optimization algorithm*** in MATLAB.

7. Run the file ***DEPF/bi-objective fruit fly optimization algorithm/main.mlx***.

8. Output the file ***DEPF/bi-objective fruit fly optimization algorithm/output_data*** including the NMI and ARI results of pollen data.
    > pollen: NMI<- 0.96,   ARI<-0.94;