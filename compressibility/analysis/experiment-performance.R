#### Required Libraries ####

require(plyr)
source("analysis/DBDA2E-utilities.R")

#### Load Data ####

trialdata <- read.csv('data/raw/raw-data-no-mturk-id.csv')

#### Extract Familiarity Tests with Target Triple ####

familiarity_data <- trialdata[trialdata$trial_type_detail=="test" | trialdata$trial_type_detail == "easy",]

familiarity_data$correct <- mapply(function(target, response){
  if(target=="first" && response == 1) { return(1) }
  if(target=="second" && response == 3) { return(1) }
  return(0)
}, familiarity_data$correct_pair, familiarity_data$Q0)

#### Collapse data into form for Bayesian model ####

modeldata <- ddply(familiarity_data, .(mturk_id, condition), function(s){
  return(c(y=sum(s$correct), N=length(s$correct)))
})
modeldata$subject <- 1:nrow(modeldata)
modeldata$condition <- as.numeric(factor(modeldata$condition))
modeldata$mturk_id <- NULL

datalist <- list(
  y = modeldata$y,
  N = modeldata$N,
  cond = modeldata$condition,
  Ntotal = nrow(modeldata)
)

save(modeldata, file="data/output/experiment_data.Rdata")

#### Run JAGS model ####

result = run.jags('analysis/JAGS-models/experiment-model.txt', monitor=c('baseline', 'diff'), n.chains=3, data=datalist, adapt=1000,burnin=1000,sample=20000)

# check R-hat statistics
print(result)

# check effective sample size
effectiveSize(result)

# posterior distributions
codaSamples = as.mcmc.list( result )
mcmcMat = as.matrix(codaSamples)
layout(matrix(1:2,nrow=1))
plotPost(mcmcMat[,'baseline'], xlab="Baseline probability of a correct response",cex.lab = 1)
plotPost(mcmcMat[,'diff'], xlab="Difference in probability of a \ncorrect response between conditions",cex.lab = 1)

save(result, file="data/output/MCMC_sample_experiment_data.Rdata")





