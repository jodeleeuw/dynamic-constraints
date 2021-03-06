setwd('~/letters-typing-three-onscreen')

args <- commandArgs(TRUE)

# analysis options
# subset.data - TRUE to run the JAGS model on only 20 subjects for faster MCMC sampling during development
subset.data <- F
subset.amount <- 50

# libraries
require(plyr, lib.loc = '~/R-packages')
require(tidyr, lib.loc = '~/R-packages')
require(rjags)

# load the data
data.all <- read.csv('data/all-data.csv')

# get only the data from test trials
data.test <- subset(data.all, practice == 0)

# add a column that indicates how many times a letter has appeared in the experiment
n_subjects <- length(unique(data.test$subject))
data.test$appearanceCount <- rep(as.vector(sapply(1:72, function(x){return(rep(x,12))})), n_subjects)

# get subset of data for the model
data.for.model <- subset(data.test, correct==1 & triple_type == 'critical' & triple_position%in%c(1,3), c('subject','cond','appearanceCount','triple_position','rt'))
 
# get data in right format
data.for.model$subject <- as.numeric(factor(data.for.model$subject))
data.for.model$cond <- factor(as.character(data.for.model$cond), levels=c('known','unknown','one'))
data.for.model$cond <- as.numeric(data.for.model$cond)
data.for.model <- data.for.model %>% spread(triple_position, rt)

colnames(data.for.model) <- c('subject', 'cond', 't', 'rt.N','rt.W')

if(subset.data){
  data.for.model <- subset(data.for.model, subject<=subset.amount)
}

save(data.for.model, file="data/data-for-individual-model.Rdata")

# get subject -> condition lookup vector
cond.vector <- data.for.model[!duplicated(data.for.model$subject),]$cond

data.model <- as.list(data.for.model)
data.model$cond <- as.numeric(as.character(cond.vector))
data.model$ndata <- nrow(data.for.model)
data.model$nsubjects <- length(unique(data.for.model$subject))
#data.model$ncond <- length(unique(data.differences$cond))

# generate a random seed
random.seed <- args[1]
set.seed(random.seed)

# run the jags model ####
burnin <- 10000
adapt <- 2000
n.chains <- 1
sample <- 20000
thin <- 4

rand.inits <- lapply(1:n.chains, function(s){
  return(list(
    .RNG.seed=round(runif(1, min=0, max=.Machine$integer.max)),
    .RNG.name=sample(c("base::Wichmann-Hill","base::Marsaglia-Multicarry","base::Super-Duper","base::Mersenne-Twister"), 1)[[1]]
  ))
})

parameters <- c(
  'a.adapt','b.adapt','c.adapt',
  'a.adapt.group','a.adapt.group.sd',
  'b.adapt.group.mode','b.adapt.group.concentration',
  'c.adapt.group','c.adapt.group.sd',
  'b.W','c.W','offset.W',
  'b.W.group.mode', 'b.W.group.concentration', 'c.W.group', 'c.W.group.sd',
  'is.learner', 'learner.cond', 'offset.mode', 
  'sd.rt' 
)
#jags.result.individual <- run.jags('jags-models/individual-level.txt', data=data.model, monitor = parameters, n.chains=4, burnin=10000, sample=5000, thin=2, method='parallel')
#save(jags.result.individual, file="data/jags-result-individual.Rdata")

print(paste0('Building model and adapting at ', Sys.time()))
jags.m <- jags.model('jags-models/individual-level.txt', data=data.model, n.adapt = adapt, n.chains = n.chains, inits=rand.inits)
print(paste0('Starting burn-in at ',Sys.time()))
update(jags.m, n.iter=burnin)
print(paste0('Starting sampling at ',Sys.time()))
jags.result.individual <- coda.samples(jags.m, parameters, sample, thin = thin)
print(paste0('Sampling complete at ',Sys.time()))
save(jags.result.individual, jags.m, random.seed, file=paste0("data/individual/jags-result-individual-",random.seed,".Rdata"))

Sys.sleep(10.0)
