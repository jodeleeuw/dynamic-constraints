library(ggplot2)
library(plyr)
library(coda)

all.mcmc.files <- list.files(path="data/mcmc")

df.p <- data.frame(subject=numeric(), plearn=numeric())
df.triples <- data.frame(subject=numeric(),triple=numeric(),param=character(),val=numeric())
for(f in all.mcmc.files){
  load(paste0('data/mcmc/',f))

  p <- mean(jags.result.single.subject$is.learner)
  onsets.four <- summary(jags.result.single.subject$offset, mean)$stat[9:12]
  b.four <- summary(jags.result.single.subject$b, mean)$stat[9:12]
  id <- gsub("[^0-9]","",f)
  df <- data.frame(subject=rep(id,4), triple=c(1,2,3,4), onset=onsets.four, b=b.four)
  df.triples <- rbind(df.triples,df)
  df.p <- rbind(df.p, data.frame(subject=id,plearn=p))
}

# only get onsets for learners

learning.subjects <- as.character(subset(df.p, plearn >= .95)$subject)
df.triples.learning <- subset(df.triples, subject%in%learning.subjects)

df.triples.learning.filter <- df.triples.learning
df.triples.learning.filter$onset <- round(df.triples.learning.filter$onset)
df.triples.learning.filter$onset <- mapply(function(b,o){
  if(b < 0.2) { return(NA) }
  else { return(o) }
},df.triples.learning.filter$b,df.triples.learning.filter$onset)

# in the right format for model fitting
library(tidyr)
df.triples.learning.filter$b <- NULL
onsets <- df.triples.learning.filter %>% spread(triple,onset)
onsets.mat <- as.matrix(na.omit(onsets[,2:5]))

# sort onsets
onsets.mat.sort <- t(apply(onsets.mat,1,sort))

#### fit the model ####
library(DEoptim)
source('model/dependent-accumulator-model.R')

reps  <- 1000
n <- dim(onsets.mat.sort)[1]
model <- function(params){
  
  p <- params[1]
  end <- params[2]
  boost <- params[3]
  
  err.sum <- 0
  
  f.times <- sapply(1:reps, function(x){ dependent.accumulators(4, p[i], end, boost) })
  
  f.times.avg <- apply(f.times, 1, mean)
  
  # run the model
  for(i in 1:n){
    # calculate RMSE
    err <- dist(rbind(f.times.avg, onsets.mat.sort[i,]))
    err.sum <- err.sum + err
  }
  
  return(err.sum)
}

mappingFun <- function(x){
  x[2] <- round(x[2])
  return(x)
}

result <- DEoptim(model, lower=c(0.00001, 1, 0), upper=c(1, 250, 500), fnMap = mappingFun, control=list(NP=600,itermax=400) )

# fit the model using first onset and difference scores ####

onsets.mat.sort.diff <- t(apply(onsets.mat.sort, 1, function(x){ return(c(x[1],cumsum(diff(x))))}))

model <- function(params){
  
  p <- params[1]
  end <- params[2]
  boost <- params[3]
  
  err.sum <- 0
  
  f.times <- t(sapply(1:reps, function(x){ dependent.accumulators(4, p[i], end, boost) }))
  f.times.diff <- t(apply(f.times, 1, function(x){ return(c(x[1],cumsum(diff(x))))}))
  
  f.times.avg <- apply(f.times.diff, 2, mean)
  
  # run the model
  for(i in 1:n){
    # calculate RMSE
    err <- dist(rbind(f.times.avg, onsets.mat.sort.diff[i,]))
    err.sum <- err.sum + err
  }
  
  return(err.sum)
}

mappingFun <- function(x){
  x[2] <- round(x[2])
  return(x)
}

result.diff <- DEoptim(model, lower=c(0.00001, 1, 0), upper=c(1, 250, 500), fnMap = mappingFun, control=list(NP=400,itermax=200) )
