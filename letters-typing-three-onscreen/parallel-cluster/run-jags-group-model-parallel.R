# set wd
setwd('~/letters-typing-three-onscreen')

# get command line args
args <- commandArgs(T)

# load required packages
require(plyr, lib.loc='~/R-packages')
require(rjags)

# load data
data.all <- read.csv('data/all-data.csv')

# summarize data for model ####
data.test <- subset(data.all, practice==0)
n_subjects <- length(unique(data.test$subject))
data.test$appearanceCount <- rep(as.vector(sapply(1:72, function(x){return(rep(x,12))})), n_subjects)
data.test.correct <- subset(data.test, correct==1 & triple_type=='critical')
data.test.correct$rt <- as.numeric(as.character(data.test.correct$rt))
data.summary <- ddply(data.test.correct, .(cond, triple_position, appearanceCount), function(s){
  return(c(rt=mean(s$rt)))
})
data.summary$cond <- as.numeric(data.summary$cond)
data.summary$triple_position <- as.numeric(factor(as.character(data.summary$triple_position)))

colnames(data.summary) <- c("cond", "position", "t", "rt")

#save(data.summary, file='data/data-group-level.Rdata')

data.model <- as.list(data.summary)
data.model$ndata <- nrow(data.summary)

# generate a random seed
random.seed <- args[1]
set.seed(random.seed)

# run the model ####
burnin <- 10000
adapt <- 5000
n.chains <- 4
sample <- 100000
thin <- 25

rand.inits <- lapply(1:n.chains, function(s){
  return(list(
    .RNG.seed=round(runif(1, min=0, max=.Machine$integer.max)),
    .RNG.name=c("base::Wichmann-Hill","base::Marsaglia-Multicarry","base::Super-Duper","base::Mersenne-Twister")[(s%%n.chains)+1]
  ))
})

monitor.parameters <- c(
  'a.cond.position','b.cond.position','c.cond.position',
  'a.overall.mode','a.overall.sd','b.overall.mode','b.overall.concentration',
  'c.overall.mode','c.overall.sd',
  'sd.rt'
)

jags.m <- jags.model('jags-models/group-level.txt', data=data.model, n.adapt = adapt, n.chains = n.chains, inits=rand.inits)
update(jags.m, n.iter=burnin)
jags.result.group <- coda.samples(jags.m, monitor.parameters, sample, thin = thin)

save(jags.result.group, jags.m, random.seed, file=paste0("data/group/jags-result-group-",random.seed,".Rdata"))

Sys.sleep(10.0)
