# DEPF
We propose a dynamic ensemble pruning framework (DEPF) to identify and interpret single-cell molecular heterogeneity. In particular, we develop and evaluate a novel indicator based on the silhouette coefficient to determine the direction of the optimization of the bi-objective function. Meanwhile, a hierarchical autoencoder is employed to project the high-dimensional scRNA-seq data into multiple low-dimensional latent space sets, and then a clustering ensemble is produced in latent space by the basic clustering algorithm. Following that, a bi-objective fruit fly optimization algorithm is designed to dynamically prune the low-quality basic clusterings in the ensemble.

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

## Citation

1. scDHA

    > "Tran, D., Nguyen, H., Tran, B., La Vecchia, C., Luu, H. N., & Nguyen, T. (2021).", "Fast and precise single-cell data analysis using a hierarchical autoencoder.", "Nature Communications, 12, 1029.", "URL: https://www.nature.com/articles/s41467-021-21312-2"

2. the basic clustering algorithm

    > "D. Huang, C.-D. Wang, J.-S. Wu, J.-H. Lai, and C.-K. Kwoh.", "Ultra-Scalable Spectral Clustering and Ensemble Clustering.", "IEEE Transactions on Knowledge and Data Engineering, 2020.", DOI: https://doi.org/10.1109/TKDE.2019.2903410   

3. the consensus clustering algorithm

    > "Dong Huang, Chang-Dong Wang, and Jian-Huang Lai.", "Locally weighted ensemble clustering.", "IEEE Transactions on Cybernetics, 2018, 48(5), pp.1460-1473."  


