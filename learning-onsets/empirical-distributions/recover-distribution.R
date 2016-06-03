library(jsonlite)

index.to.finish.times <- function(idx, n, max){
  curr <- idx
  f.times <- c()
  for(i in 0:(n-1)){
    v <- floor( curr / (max+1)^(n-i-1) ) + 1
    curr <- curr %% (max+1)^(n-i-1)
    f.times <- c(f.times,v)
  }
  return(f.times)
}

log.likelihood.from.json <- function(finish.times, jsonfile, min.likelihood=0){
  data <- fromJSON(jsonfile)
  max.time <- data$parameters$max[[1]]
  cum.index <- cumsum(data$result$lengths)
  if(!is.null(nrow(finish.times))){
    log.sum <- 0
    for(i in 1:nrow(finish.times)){
      index <- mapToIndex(finish.times[i,], max.time) + 1 # rcpp uses zero-based index
      result.loc <- which(index <= cum.index)[[1]]
      count <- data$result$values[[result.loc]]
      log.likelihood <- log( max(count / data$parameters$reps[[1]], min.likelihood) )
      log.sum <- log.sum + log.likelihood
    }
  } else {
    index <- mapToIndex(finish.times, max.time) + 1 # rcpp uses zero-based index
    result.loc <- which(index <= cum.index)[[1]]
    count <- data$result$values[[result.loc]]
    log.sum <- log( max(count / data$parameters$reps[[1]], min.likelihood) )
  }
  return(list(
    p = data$parameters$p[[1]],
    end = data$parameters$end[[1]],
    boost = data$parameters$boost[[1]],
    log.likelihood = log.sum
  ))
}

distribution.dataframe.from.json <- function(jsonfile){
  datalist <- fromJSON(jsonfile)
  v <- inverse.rle(datalist$result)
  v.data <- which(v > 0)
  df <- as.data.frame(do.call(rbind, lapply(v.data,function(i){
    idx <- i - 1 # zero based index for Rcpp compatibility
    f <- index.to.finish.times(idx, datalist$parameters$n, datalist$parameters$max)
    cnt <- v[i]
    return(c(f,cnt))
  })))
  colnames(df) <- c(sapply(1:datalist$parameters$n, function(x){return(paste0('A',x))}),'count')
  return(df)
}

condition.histogram <- function(df, ftimes=c()){
  sub.df <- df
  if(length(ftimes)>0){
    for(i in 1:length(ftimes)){
      sub.df <- sub.df[sub.df[,i]==ftimes[i],]
    }
  }
  d <- sub.df[,length(ftimes)+1]
  hist(rep(d, sub.df$count), breaks=(min(d)-1):max(d))
}

# jsonfile <- 'empirical-distributions/model-recovery-distributions/0.02-3-0-4.json'
# xx <- distribution.dataframe.from.json(jsonfile)
# 
# condition.histogram(xx, c(7,7,7))
