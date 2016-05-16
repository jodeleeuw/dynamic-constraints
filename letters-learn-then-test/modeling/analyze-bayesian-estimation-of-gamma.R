library(runjags)
source('modeling/DBDA2E-utilities.R')

load('modeling/output/jags-result-gamma-estimation.Rdata')

effectiveSize(jags.result)

plot(jags.result)

codaSamples = as.mcmc.list( jags.result )
mcmcMat = as.matrix(codaSamples)

plotPost(mcmcMat[,'gamma[1]'])
