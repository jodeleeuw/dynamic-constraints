require(runjags)
source("analysis/DBDA2E-utilities.R")

#### load in model data and experiment data ####

load('data/output/model_run_data.Rdata')
model_data <- model_run_data
model_data$condition <- as.numeric(model_data$condition)
model_data$model <- as.numeric(model_data$model)

load('data/output/experiment_data.Rdata')
experiment_data <- modeldata

#### format data for jags model ####

jags_data <- data.frame(y=numeric(),n=numeric,a=numeric(),b=numeric(),model=numeric())

for(i in 1:nrow(experiment_data)){
  y = experiment_data$y[i]
  n = experiment_data$N[i]
  md <- subset(model_data, condition==experiment_data$condition[i])
  md$y <- y
  md$n <- n
  md$a <- as.numeric(as.character(md$target))
  md$b <- as.numeric(as.character(md$foil))
  md$target <- NULL
  md$foil <- NULL
  jags_data <- rbind(jags_data, md)
}

jags_data$a <- mapply(function(a,m){
  if(m >= 2){ return(-a) }
  else { return(a) }
}, jags_data$a, jags_data$model)


jags_data$b <- mapply(function(a,m){
  if(m >= 2){ return(-a) }
  else { return(a) }
}, jags_data$b, jags_data$model)

jagsdatalist = list(
  y = jags_data$y,
  n = jags_data$n,
  a = jags_data$a,
  b = jags_data$b,
  m = jags_data$model,
  num_rows = length(jags_data$y)
)

initslist = list(
  gamma = c(0.18,0.05,1)
)
#### run model ####

result <- run.jags(model='analysis/JAGS-models/gamma-fit-model.txt', monitor=c('gamma'), 
         data=jagsdatalist, n.chains=3,
         inits = initslist,
         burnin=1000, sample=4000, adapt=1000)

print(result)

save(result, file="data/output/MCMC-sample-gamma.Rdata")

codaSamples = as.mcmc.list( result )
mcmcMat = as.matrix(codaSamples)

plotPost(mcmcMat[,'gamma[1]'])
plotPost(mcmcMat[,'gamma[2]'])
plotPost(mcmcMat[,'gamma[3]'])
