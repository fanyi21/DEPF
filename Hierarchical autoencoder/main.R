library(R.matlab)
library(SingleCellExperiment)
#(scDHA)
#library(Seurat)
current.path <- getwd()
current.path <- sub('/Hierarchical autoencoder','',current.path)
path <- paste(current.path,"/scRNAseqData", sep="") 
fileName <- dir(path)
datalistname <- sub('.rds','',fileName)

for (i in 1:length(fileName)) {
  
  d <- readRDS(paste(path,"/", fileName[[i]], sep=""))
  
  original_data <- t(SummarizedExperiment::assay(d))
  
  original_label <- as.numeric(factor(d$cell_type1))
  
  result <- scDHA(dataname = datalistname[[i]], original_label = original_label, 
                  data = original_data, seed = 1)
  
  rm(d)
  
  rm(original_data)
  
  rm(original_label)
  
  rm(result)
  
}




