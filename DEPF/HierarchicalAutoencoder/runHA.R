library(R.matlab)
library(SingleCellExperiment)
library(scDHA)
library(pryr) # record memory
devtools::load_all(".")
current.path <- getwd()
current.path <- sub('/HierarchicalAutoencoder','',current.path)
path <- paste(current.path,"/scRNAseqData", sep="") 
fileName <- dir(path)
datalistname <- sub('.rds','',fileName)
for (i in 1:length(fileName)) {
  print(fileName[[i]])
  d <- readRDS(paste(path,"/", fileName[[i]], sep=""))
  original_data <- t(SummarizedExperiment::assay(d))
  
  original_label <- as.numeric(factor(d$cell_type1))
  
  write.csv2(colnames(original_data),
             file = paste(current.path, "/OutputData",
                          "/gene_name.csv", sep = ""))
  
  write.csv2(rownames(original_data),
             file = paste(current.path, "/OutputData",
                          "/cell_name.csv", sep = ""))
  
  result <- scDHA(dataname = datalistname[[i]], 
                  original_label = original_label, 
                  data = original_data, 
                  seed = 1, 
                  ncores = 10L)
  rm(d)
  rm(original_data)
  rm(original_label)
  rm(result)
}