################### install CRAN package ########################
install.packages("./clusterCrit_1.2.8.tar.gz", repos = NULL, type = "source")
pkg <- c("R.matlab", 
         "mclust", 
         "tidyverse")
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE, 
                     repos = "http://cran.us.r-project.org")
  sapply(pkg, require, character.only = TRUE)
}
ipak(pkg)
############### install BiocManager package #####################
BiocManager::install("SingleCellExperiment")
################# install github package ######################## 
devtools::install_github('duct317/scDHA')
library(scDHA)
torch::install_torch()