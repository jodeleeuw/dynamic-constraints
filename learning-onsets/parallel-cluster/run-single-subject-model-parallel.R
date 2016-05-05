setwd('~/learning-onsets')

args <- commandArgs(T)

library(plyr, lib.loc='~/R-packages')
library(tidyr, lib.loc='~/R-packages')
library(rjags)

# load the data
data.all <- read.csv('data/all-data.csv')

# filter for subjects only in the unknown words condition
data.condition.filter <- subset(data.all, cond=='unknown')

# get only the data from test trials
data.test <- subset(data.condition.filter, practice == 0)

# add a column that indicates how many times a letter has appeared in the experiment
n_subjects <- length(unique(data.test$subject))
data.test$appearanceCount <- rep(as.vector(sapply(1:72, function(x){return(rep(x,12))})), n_subjects)

# get subset of data for the model
data.for.model <- subset(data.test, correct==1 & triple_position%in%c(1,2,3), c('subject','appearanceCount','stimulus', 'rt'))

# create column that index which letter is being tested in a specific way
# unpredictable elements are 1-4, predictable 5-12
data.for.model$symbol <- as.numeric(factor(as.character(data.for.model$stimulus), levels=c('N','T','R','Y','I','U','E','A','W','C','H','D')))
data.for.model$symbol.type <- as.numeric(data.for.model$symbol > 4) + 1

# get data in right format
data.for.model$subject <- as.numeric(factor(data.for.model$subject))
data.for.model$stimulus <- NULL
colnames(data.for.model) <- c('subject', 't', 'rt','symbol','symbol.type')

#save(data.for.model, file="data/data-for-individual-model.Rdata")

# subset the data for this particular subject
which.subject <- args[1]
data.model.subset <- subset(data.for.model, subject==which.subject)
data.jags <- as.list(data.model.subset)
data.jags$ndata <- nrow(data.model.subset)
save(data.model.subset, file=paste0("data/jags-input/data-for-jags-single-subject-",which.subject,".Rdata"))

# generate a random seed
random.seed <- args[1]
set.seed(random.seed)

# run the jags model ####
burnin <- 2000
adapt <- 2000
n.chains <- 4
sample <- 200000
thin <- 20

rand.inits <- lapply(1:n.chains, function(s){
  return(list(
    .RNG.seed=round(runif(1, min=0, max=.Machine$integer.max)),
    .RNG.name=sample(c("base::Wichmann-Hill","base::Marsaglia-Multicarry","base::Super-Duper","base::Mersenne-Twister"), 1)[[1]]
  ))
})


# run
parameters <- c('a.adapt','b.adapt','c.adapt','b','c','offset','b.pseudo','c.pseudo','sd.rt','is.learner','p.learner')

print(paste0('Building model and adapting at ', Sys.time()))
jags.m <- jags.model('jags-models/single-subject-model.txt', data=data.jags, n.adapt = adapt, n.chains = n.chains, inits=rand.inits)
print(paste0('Starting burn-in at ',Sys.time()))
update(jags.m, n.iter=burnin)
print(paste0('Starting sampling at ',Sys.time()))
jags.result.single.subject <- jags.samples(jags.m, parameters, sample, thin = thin)
print(paste0('Sampling complete at ',Sys.time()))
save(jags.result.single.subject, jags.m, file=paste0("data/mcmc/jags-result-single-subject-",which.subject,".Rdata"))

Sys.sleep(10.0)








