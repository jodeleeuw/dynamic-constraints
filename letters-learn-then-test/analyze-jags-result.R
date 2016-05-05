source('jags model/DBDA2E-utilities.R')
library(runjags)

load('data/output/jags.experiment.result.Rdata')

# look at the diagnostic plots for the MCMC chains ####
plot(jags.result)

# check effective sample size
effectiveSize(jags.result)

# plot the 95% HDIs ####
mcmcMat <- as.matrix(as.mcmc.list(jags.result))

layout(matrix(1:2, nrow=1))
plotPost(mcmcMat[,'baseline'], xlab="Baseline probability of a correct response",cex.lab = 1)
plotPost(mcmcMat[,'diff'], xlab="Difference in probability of a \ncorrect response between conditions",cex.lab = 1)
