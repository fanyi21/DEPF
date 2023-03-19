rm(list = ls())
gc()
library(R.matlab)
library(SingleCellExperiment)
library(tidyverse)
library(data.table)
library(Seurat)
library(Matrix)
#########################  data path  ------------------------------------------
algorithm.dataname <- "Louvain_resolution_"
print("run Louvain")
res <- seq(from = 0.2,to = 1,length.out = 5)  #######  设定一个固定值
current.path <- getwd()
package.path <- sub('/HierarchicalAutoencoder', '', current.path)
data.path <- paste(package.path, "/scRNAseqData/", sep = "")
out.path <- paste(package.path, "/OutputData/", sep = "")
fileName <- dir(data.path)
dataname <- sub('.rds','',fileName)
#######################  generate cluster ensemble  --------------------------
cell_name <- read.csv(paste(out.path,
                            "/cell_name.csv", sep = ""))
clust.ensemble = function(num.latent = 9, res, out.path, dataname) {
  clt <- cell_name
  rownames(clt) <- clt[[1]]
  clt[[1]] <- c()
  for (i in 1:num.latent) {
    cat("**********************************************",".\n")
    cat("output 9 of ", i, " latent: ", dataname, ".\n")
    cat("**********************************************",".\n")
    filename <- paste(out.path,"/9_latent_data/",
                      i,"/",dataname,i,".mat",sep = "")
    latent_data <-
      t(as.data.frame(readMat(filename, lantent_data = latent[[i]])))
    latent_data <- latent_data[-16,]
    colnames(latent_data) <- rownames(clt)
    for (j in 1:length(res)) {
      cat("----------------------------------------------",
            ".\n")
      cat(" resolution: ", res[j], ".\n")
      cat("----------------------------------------------",
            ".\n")
      # We will now store this as a custom dimensional reduction called 'mds'
      SMC <-
          CreateSeuratObject(counts = latent_data, project = "mye")
      SMC[["mds"]] <-
          CreateDimReducObject(
            embeddings = t(latent_data),
            key = "MDS_",
            assay = DefaultAssay(SMC)
          )
      SMC <- FindNeighbors(SMC, reduction = 'mds')
      # algorithm <- 1 = original Louvain algorithm  4 = Leiden algorithm
      if (algorithm.dataname == "Louvain_resolution_") {
        print("============  Louvain   ============")
        SMC <- FindClusters(SMC, resolution = res[j],
                              algorithm = 1)
      } else {
        stop("set Louvain algorithm")
      }
      clt[[length(res) * (i - 1) + j]] <- as.numeric(Idents(SMC))
      colnames(clt)[[length(res) * (i - 1) + j]] <-
          c(paste("latent", i, "_", "resolution_", res[j], sep = ""))
    }
  }
  clt
}
######################             main          -----------------------------
runLouvain <- function(res=1, ensemble_num=9){
  if (ensemble_num < 2) {
    ensemble_num <- 2
  }else if (ensemble_num >9) {
    ensemble_num <- 9
  }
  for (rr in 1:length(res)) {
    clt <- clust.ensemble(
      num.latent = ensemble_num,
      res = res[rr],
      out.path = out.path,
      dataname = dataname
    )
    write.table(
      clt,
      file = paste(out.path, "/", algorithm.dataname, res[rr], ".csv", sep = ""),
      row.names = FALSE,
      col.names = FALSE
    )
  }
}