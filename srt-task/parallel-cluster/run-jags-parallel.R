setwd('~/srt-task')
args <- commandArgs(T)

library(rjags)
library(plyr, lib.loc='~/R-packages')

data.all <- read.csv('data/all-data.csv')

data.test <- subset(data.all, trial_type=='serial-reaction-time', c('subjid','rt','correct','which_triple','triple_part'))
data.test$t <- rep(sapply(1:160, function(x){rep(x,12)}), length(unique(data.test$subjid)))
data.test.correct <- subset(data.test, correct==1)
data.test.correct$correct <- NULL
data.test.correct$triple_part <- as.numeric(factor(data.test.correct$triple_part, levels=c('start','middle','end')))
data.test.correct$symbol.type <- as.numeric(data.test.correct$triple_part > 1) + 1
data.test.correct$symbol <- as.numeric(data.test.correct$which_triple)*3 + data.test.correct$triple_part - 3
data.test.correct$triple_part <- NULL
data.test.correct$which_triple <- NULL

# subset the data for this particular subject
which.subject <- args[1]
data.subset <- subset(data.test.correct, subjid==which.subject)
data.jags <- as.list(data.subset)
data.jags$ndata <- nrow(data.subset)

# generate a random seed
random.seed <- args[2]
set.seed(random.seed)

# run the jags model ####
burnin <- 1000
adapt <- 1000
n.chains <- 1
sample <- 20000
thin <- 1

rand.inits <- lapply(1:n.chains, function(s){
  return(list(
    .RNG.seed=round(runif(1, min=0, max=.Machine$integer.max)),
    .RNG.name=sample(c("base::Wichmann-Hill","base::Marsaglia-Multicarry","base::Super-Duper","base::Mersenne-Twister"), 1)[[1]]
  ))
})


# run
parameters <- c('a.adapt','b.adapt','c.adapt','b','c','offset','b.pseudo','c.pseudo','sd.rt','is.learner')

print(paste0('Building model and adapting at ', Sys.time()))
jags.m <- jags.model('jags-models/single-subject-model.txt', data=data.jags, n.adapt = adapt, n.chains = n.chains, inits=rand.inits)
print(paste0('Starting burn-in at ',Sys.time()))
update(jags.m, n.iter=burnin)
print(paste0('Starting sampling at ',Sys.time()))
jags.result.single.subject <- coda.samples(jags.m, parameters, sample, thin = thin)
print(paste0('Sampling complete at ',Sys.time()))
save(jags.result.single.subject, jags.m, file=paste0("data/mcmc/jags-result-single-subject-",which.subject,"-",args[2],".Rdata"))

Sys.sleep(10.0)
