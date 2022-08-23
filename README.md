# DEPF
We propose a dynamic ensemble pruning framework (DEPF) to identify and interpret single-cell molecular heterogeneity. In particular, we develop and evaluate a novel indicator based on the silhouette coefficient to determine the direction of the optimization of the bi-objective function. Meanwhile, a hierarchical autoencoder is employed to project the high-dimensional scRNA-seq data into multiple low-dimensional latent space sets, and then a clustering ensemble is produced in latent space by the basic clustering algorithm. Following that, a bi-objective fruit fly optimization algorithm is designed to dynamically prune the low-quality basic clusterings in the ensemble.

## DATA AVAILABILITY
The unsupervised dimensionality reduction is implemented in R.
The basic clustering algorithm, objective function, dynamic ensemble pruning are implemented in MATLAB. 
### R enviroment
R 4.1.1


### MATLAB enviroment
 MATLAB 2019b 
