#' @import doParallel torch
#' @importFrom parallel makeCluster clusterEvalQ stopCluster
#' @importFrom matrixStats colSums2 rowSds rowMeans2 rowMaxs rowMins colSds colMins
#' @importFrom stats predict
#' @importFrom foreach %dopar% foreach
#' @importFrom stats quantile
#' @importFrom igraph membership
#' @title Hierarchical autoencoder
#' @description The main function to perform dimension deduction and clustering.
#' @param data Gene expression matrix, with rows represent samples and columns represent genes.
#' @param k Number of clusters, leave as default for auto detection. Has no effect when \code{do.clus = False}.
#' @param method Method used for clustering. It can be "scDHA" or "louvain". The default setting is "scDHA".
#' @param sparse Boolen variable indicating whether data is a sparse matrix. The input must be a non negative sparse matrix.
#' @param n Number of genes to keep after feature selection step.
#' @param ncores Number of processor cores to use.
#' @param gen_fil Boolean variable indicating whether to perform scDHA gene filtering before performing dimension deduction and clustering.
#' @param do.clus Boolean variable indicating whether to perform scDHA clustering. If \code{do.clus = False}, only dimension deduction is performed.
#' @param sample.prob Probability used for classification application only. Leave this parameter as default, no user input is required.
#' @param seed Seed for reproducibility.
#' @return List with the following keys:
#' \itemize{
#' \item cluster - A numeric vector containing cluster assignment for each sample. If \code{do.clus = False}, this values is always \code{NULL}.
#' \item latent - A matrix representing compressed data from the input data, with rows represent samples and columns represent latent variables.
#' }
#' @export


scDHA <- function(dataname = dataname, original_label = original_label, 
data = data, k = NULL, method = "scDHA", sparse = FALSE, 
n = 5000, ncores = 10L, gen_fil = TRUE, do.clus = TRUE, 
sample.prob = NULL, seed = NULL) {
  RhpcBLASctl::blas_set_num_threads(max(2, ncores))
  current.path <- getwd()
  current.path <- sub('/HierarchicalAutoencoder','',current.path)
  
  K = 3
  if(!method %in% c("scDHA", "louvain"))
  {
    stop("'method' should be one of 'scDHA', or 'louvain'")
  }
  if(sparse) {
    if(min(data) < 0) stop("The input must be a non negative sparse matrix.")
    if(max(data) - min(data) > 100)
    {
      data@x <- log2(data@x + 1)
    }
    data <- normalize_data_sparse(data)
  }  else {
    if(max(data) - min(data) > 100)
    {
      if(min(data) < 0)
      {
        if(nrow(data) == ncol(data))
        {
          data <- t(data)
          data <- data - matrixStats::rowMins(data)
          data <- t(data)
        } else {
          data <- data - matrixStats::colMins(data)
        }
      }
      data <- log2(data + 1)
    }
    data <- normalize_data_dense(data)
  }
  data@x[is.na(data@x)] <- 0
  
  gc()
  if(nrow(data) >= 50000)
  {
    res <- scDHA.big(
    dataname = dataname, original_label = original_label, data = data, k = k, 
    method = method, K = K, n = n, ncores = ncores, gen_fil = gen_fil, 
    do.clus = do.clus, sample.prob = sample.prob, seed = seed)
  } else {
    res <- scDHA.small(
    dataname = dataname, original_label = original_label, data = data, k = k, 
    method = method, K = K, n = n, ncores = ncores, gen_fil = gen_fil, 
    do.clus = do.clus, sample.prob = sample.prob, seed = seed)
  }
  res
}

in_test <- function() identical(Sys.getenv("IN_TEST_scDHA"), "true")

gene.filtering <- function(data.list, original_dim, batch_size, ncores.ind, ncores, wdecay, seed)
{
  or <- list()
  cl <- parallel::makeCluster(min(3, ncores), outfile = "/dev/null")
  registerDoParallel(cl, cores = min(3, ncores))
  parallel::clusterEvalQ(cl,{
    library(scDHA)
  })
  i <- NULL
  or <- foreach(i = seq(3)) %dopar%
    {
      if (!is.null(seed))
      {
        set.seed((seed+i))
        torch_manual_seed((seed+i))
      } 
      
      data.tmp <- data.list[[i]]
      batch_size <- max(round(nrow(data.tmp)/50),2)
      epochs <- 10
      
      torch::torch_set_num_threads(ifelse(nrow(data.tmp) < 1000 | ncores.ind == 1, 1, 2))
      RhpcBLASctl::blas_set_num_threads(1)
      
      if(in_test())
      {
        batch_size <- nrow(data.tmp)
        epochs <- 5
      }
      
      data_train <- scDHA_dataset(data.tmp)
      dl <- data_train %>% dataloader(batch_size = batch_size, shuffle = TRUE, drop_last = TRUE)
      
      model <- scDHA_AE(original_dim, 32)
      
      optimizer <- optim_adamw(model$parameters, lr = 1e-3, weight_decay = wdecay, eps = 1e-7)
      
      for (epoch in 1:epochs) {
        optimizer$zero_grad()
        for (b in enumerate(dl)) {
          output <- model(b[[1]])
          loss <- torch::nnf_mse_loss(output, b[[1]])
          loss$backward()
          if(check_grad_nan(model$parameters))
          {
            optimizer$zero_grad()
            next()
          }
          optimizer$step()
          optimizer$zero_grad()
          with_no_grad({
            model$fc1$weight$copy_(model$fc1$weight$data()$clamp(min=0))
          })
        }
      }
      
      W <- t(as.matrix(model$fc1$weight))
      Wsd <- matrixStats::rowSds(W)
      Wsd[is.na(Wsd)] <- 0
      Wsd <- (Wsd-min(Wsd))/(max(Wsd)-min(Wsd))
      Wsd
    }
  parallel::stopCluster(cl)
  or <- matrixStats::rowMeans2(as.matrix(data.frame(or)))
  or
}

latent.generating <- function(da, or.da, batch_size, K, ens, epsilon_std, lr, beta, 
                              original_dim_reduce, latent_dim, intermediate_dim, epochs, wdecay, ncores.ind, ncores, sample.prob, seed)
{
  latent <- list()
  cl <- parallel::makeCluster(min(K, ncores), outfile = "/dev/null")
  doParallel::registerDoParallel(cl, cores = min(K, ncores))
  parallel::clusterEvalQ(cl,{
    library(scDHA)
  })
  i <- NULL
  latent <- foreach(i = 1:K) %dopar% {
    if (!is.null(seed))
    {
      set.seed((seed+i))
      torch_manual_seed((seed+i))
    } 
    
    if(nrow(or.da) >= 50000)
    {
      da <- as.matrix(or.da[sample.int(nrow(or.da), 5000, replace = FALSE, prob = sample.prob),])
      batch_size <- round(nrow(da)/50)
    } else if(nrow(or.da) > 2000)
    {
      da <- as.matrix(or.da[sample.int(nrow(or.da), 2000, replace = FALSE, prob = sample.prob),])
      batch_size <- round(nrow(da)/50)
    }
    
    torch::torch_set_num_threads(ifelse(nrow(da) < 1000 | ncores.ind == 1, 1, 2))
    RhpcBLASctl::blas_set_num_threads(1)
    
    if(in_test())
    {
      batch_size <- nrow(da)
      epochs <- c(5,5)
    }
    
    data_train <- scDHA_dataset(da)
    dl <- data_train %>% dataloader(batch_size = batch_size, shuffle = TRUE, drop_last = TRUE)
    
    model <- scDHA_VAE(original_dim_reduce, intermediate_dim, latent_dim, epsilon_std, (nrow(da) > 500))
    
    #WU
    optimizer <- optim_adamw(model$parameters, lr = lr[1], weight_decay = wdecay, eps = 1e-7)
    for (epoch in 1:epochs[1]) {
      optimizer$zero_grad()
      for (b in enumerate(dl)) {
        output <- model(b[[1]])
        loss <- torch_mean(torch_abs(output[[3]] - b[[1]])) + torch_mean(torch_abs(output[[4]] - b[[1]]))
        loss$backward()
        if(check_grad_nan(model$parameters))
        {
          optimizer$zero_grad()
          next()
        }
        optimizer$step()
        optimizer$zero_grad()
      }
    }
    
    vae_loss <- function(x, x_pred, z_mu, z_var, beta){
      xent_loss <- torch_mean(torch_square(x - x_pred), dim = 2)
      kl_loss <- -0.5*torch_mean(1 + torch_log(z_var) - torch_square(z_mu) - z_var, dim = 2)
      loss <- xent_loss*beta + kl_loss
      torch_mean(loss)
    }
    
    #Train
    optimizer <- optim_adamw(model$parameters, lr = lr[2], weight_decay = wdecay, eps = 1e-7)
    for (epoch in 1:epochs[2]) {
      optimizer$zero_grad()
      for (b in enumerate(dl)) {
        output <- model(b[[1]])
        loss <- vae_loss(b[[1]], output[[3]], output[[1]], output[[2]], beta) + vae_loss(b[[1]], output[[4]], output[[1]], output[[2]], beta)
        loss$backward()
        if(check_grad_nan(model$parameters))
        {
          optimizer$zero_grad()
          next()
        }
        optimizer$step()
        optimizer$zero_grad()
      }
    }
    
    predict_on_sparse <- function(data, model, latent_dim)
    {
      folds <- round(seq(1, nrow(data), length.out = round(nrow(data)/10000)))
      tmp <- matrix(ncol = latent_dim, nrow = nrow(data))
      
      for (i in 2:length(folds)) {
        with_no_grad({
          tmp[folds[i-1]:folds[i], ] <- as.matrix(model$encode_mu(torch_tensor(as.matrix(data[folds[i-1]:folds[i], ]))))
        })
      }
      tmp
    }
    
    latent.tmp <- list()
    for (ite in 1:ens) {
      model$train()
      optimizer$zero_grad()
      for (b in enumerate(dl)) {
        output <- model(b[[1]])
        loss <- vae_loss(b[[1]], output[[3]], output[[1]], output[[2]], beta) + vae_loss(b[[1]], output[[4]], output[[1]], output[[2]], beta)
        loss$backward()
        if(check_grad_nan(model$parameters))
        {
          optimizer$zero_grad()
          next()
        }
        optimizer$step()
        optimizer$zero_grad()
      }
      
      model$eval()
      if(nrow(or.da) > 20000)
      {
        tmp <- predict_on_sparse(or.da, model, latent_dim)
      } else {
        with_no_grad({
          tmp <- as.matrix(model$encode_mu(torch_tensor(as.matrix(or.da))))
        })
      }
      latent.tmp[[length(latent.tmp)+1]] <- tmp
    }
    latent.tmp
  }
  parallel::stopCluster(cl)
  latent
}

scDHA.small <- function(dataname = dataname, original_label = original_label, data = data, k = NULL, method = "scDHA", K = 3, n = 5000, ncores = 10L, gen_fil = TRUE, do.clus = TRUE, sample.prob = NULL, seed = NULL) {
  set.seed(seed)
  
  ncores.ind <- as.integer(max(1,floor(ncores/K)))
  original_dim <- ncol(data)
  wdecay <- c(1e-6, 1e-3)
  batch_size <- max(round(nrow(data)/50),2)
  epochs <- c(10,20)
  
  lr <- rep(5e-4, 2) 
  gen_fil <- (gen_fil & (ncol(data) > n))
  n <- ifelse(gen_fil, min(n, ncol(data)), ncol(data))
  epsilon_std <- 0.25
  beta <- 100
  ens  <-  3
  
  intermediate_dim = 64
  latent_dim = 15
  
  #Feature selection

  if (gen_fil) {
    data.list <- lapply(seq(3), function(i) {
      if(!is.null(seed)) set.seed((seed+i))
      if(nrow(data) > 2000)
      {
        ind <- sample.int(nrow(data), 2000, replace = FALSE, prob = sample.prob)
      } else {
        ind <- seq(nrow(data))
      }
      data.tmp <- as.matrix(data[ind,])
      data.tmp
    })
    
    or <- gene.filtering(data.list = data.list, original_dim = original_dim, batch_size = batch_size, ncores.ind = ncores.ind, ncores = ncores, wdecay = wdecay[1], seed = seed)
    
    keep <- which(or > quantile(or,(1-min(n,original_dim)/original_dim)))
    
    da <- data[,keep]
    original_dim_reduce <- ncol(da)
    or.da <- da
  } else {
    da <- data
    original_dim_reduce <- ncol(da)
    or.da <- da
  }

  #Latent generation
  latent <- latent.generating(da, or.da, batch_size, K, ens, epsilon_std, lr, beta, 
                              original_dim_reduce, latent_dim, intermediate_dim, epochs, wdecay[2], ncores.ind, ncores, sample.prob, seed)
  
  gc(reset = TRUE)
  
  latent.save <- latent
  latent <- list()
  
  for (i in 1:K) {
    latent <- c(latent, latent.save[[i]])
  }
  
  # 0000000000000000000000000000000000000000000000000000000000000000000000000000
  for (i in 1:9){
    cat("output 9 of ", i, " latent: ", dataname, ".\n")
    filename <- paste(current.path,"/OutputData/9_latent_data/",i, "/", dataname, i, ".mat", sep = "")
    writeMat(filename, lantent_data = latent[[i]], original_label = original_label)
  }
  # 1111111111111111111111111111111111111111111111111111111111111111111111111111111
}

scDHA.big <- function(dataname = dataname, original_label = original_label, data = data, k = NULL, method = "scDHA", K = 3, n = 5000, ncores = 10L, gen_fil = TRUE, do.clus = TRUE, sample.prob = NULL, seed = NULL) {
  set.seed(seed)
  
  ncores.ind <- as.integer(max(1,floor(ncores/K)))
  original_dim <- ncol(data)
  wdecay <- c(1e-4, 1e-2)
  batch_size <- max(round(nrow(data)/50),2)
  epochs <- c(10,20)
  
  lr <- rep(1e-3, 2) 
  gen_fil <- (gen_fil & (ncol(data) > n))
  n <- ifelse(gen_fil, min(n, ncol(data)), ncol(data))
  epsilon_std <- 0.25
  beta <- 50
  ens  <-  3
  
  intermediate_dim = 64
  latent_dim = 15
  
  #Feature selection
  if (gen_fil) {
    data.list <- lapply(1:3, function(i) {
      if(!is.null(seed)) set.seed((seed+i))
      ind <- sample.int(nrow(data), 5000, replace = FALSE, prob = sample.prob)
      data.tmp <- as.matrix(data[ind,])
      data.tmp
    })
    
    or <- gene.filtering(data.list = data.list, original_dim = original_dim, batch_size = batch_size, ncores.ind = ncores.ind, ncores = ncores, wdecay = wdecay[1], seed = seed)
    
    keep <- which(or > quantile(or,(1-min(n,original_dim)/original_dim)))
    
    da <- 0
    or.da <- data[,keep]
    original_dim_reduce <- ncol(or.da)
  } else {
    da <- 0
    or.da <- data
    original_dim_reduce <- ncol(or.da)
  }
  rm(data)
  gc(reset = TRUE)
  
  #Latent generation
  latent <- latent.generating(da, or.da, batch_size, K, ens, epsilon_std, lr, beta, 
                              original_dim_reduce, latent_dim, intermediate_dim, epochs, wdecay[2], ncores.ind, ncores, sample.prob, seed)

  gc(reset = TRUE)
  
  latent.save <- latent
  latent <- list()
  for (i in 1:K) {
    latent <- c(latent, latent.save[[i]])
  }
  
  # 1111111111111111111111111111111111111111111111111111111111111111111111111111111
  for (i in 1:9){
    cat("output 9 of ", i, " latent: ", dataname, ".\n")
    filename <- paste(current.path,"/OutputData/9_latent_data/",i, "/", dataname, i, ".mat", sep = "")
    writeMat(filename, lantent_data = latent[[i]], original_label = original_label)
  }
  # 0000000000000000000000000000000000000000000000000000000000000000000000000000000
  
  do.clus <- FALSE
  
}

.onAttach <- function(libname, pkgname) {
  if(!torch::torch_is_installed())
  {
    packageStartupMessage("libtorch is not installed. Use `torch::install_torch()` to download and install libtorch")
  }
}