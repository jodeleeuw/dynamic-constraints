require(runjags)
source("modeling/DBDA2E-utilities.R")

#### load in model data and experiment data ####

load('modeling/output/model_run_data.Rdata')
model_run_data$condition <- as.numeric(factor(model_run_data$condition, levels=c("seeded","unseeded")))
model_run_data$model <- as.numeric(factor(model_run_data$model, levels=c("PARSER","MDLChunker")))

load('data/output/experiment-data-summary.Rdata')
data.summarized$seq_condition <- as.numeric(data.summarized$seq_condition)
data.summarized$participant <- NULL
data.summarized$p <- NULL
colnames(data.summarized) <- c('condition','y','N')

#### format data for jags model ####

jags_data <- data.frame(y=numeric(),n=numeric(),a=numeric(),b=numeric(), model=numeric())

for(i in 1:nrow(data.summarized)){
  y = data.summarized$y[i]
  n = data.summarized$N[i]
  md <- subset(model_run_data, condition==data.summarized$condition[i])
  md <- md[sample(nrow(md),50),]
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
  gamma = c(.1, .1)
)

#### run model ####

jags.result <- run.jags(model='modeling/JAGS-models/gamma-fit-model.txt', monitor=c('gamma'), 
         data=jagsdatalist, n.chains=4, burnin=1000, sample=10000, adapt=1000, inits=initslist, method='parallel')

effectiveSize(jags.result)

save(jags.result, file="modeling/output/jags-result-gamma-estimation.Rdata")

#codaSamples = as.mcmc.list( result )
#mcmcMat = as.matrix(codaSamples)

#plotPost(mcmcMat[,'gamma'])