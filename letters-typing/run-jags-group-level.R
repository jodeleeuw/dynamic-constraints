# load required packages
require(plyr)
require(runjags)
require(coda)

# load data
data.all <- read.csv('data/filtered-data.csv')

# summarize data for model ####
data.test <- subset(data.all, practice==0)
n_subjects <- length(unique(data.test$subject))
data.test$appearanceCount <- rep(as.vector(sapply(1:36, function(x){return(rep(x,12))})), n_subjects)
data.correct <- subset(data.test, correct==1 & triple_type=='critical', c('subject', 'cond','triple_position','appearanceCount', 'rt'))
data.summary <- ddply(data.correct, .(cond,triple_position,appearanceCount), function(s){
  return(c(rt=mean(s$rt)))
})
data.summary$cond <- as.numeric(data.summary$cond)
data.summary$triple_position <- as.numeric(factor(as.character(data.summary$triple_position)))
data.summary$subject <- as.numeric(factor(data.summary$subject))

colnames(data.summary) <- c("cond", "position", "t", "rt")

save(data.summary, file='data/data-summary.Rdata')

data.model <- as.list(data.summary)
data.model$ndata <- nrow(data.summary)

# run the model ####

monitor.parameters <- c(
  'a.base.z','b.base.z','c.base.z', 
  'a.cond.z', 'b.cond.z', 'c.cond.z',
  'a.position.z','b.position.z','c.position.z',
  'a.cond.position.z','b.cond.position.z','c.cond.position.z',
  'a.overall.mode','a.overall.sd','b.overall.mode','b.overall.concentration',
  'c.overall.mode','c.overall.sd',
  'sd.rt'
)

jags.result.group <- run.jags('jags-models/group-level.txt', monitor=monitor.parameters, data=data.model, adapt = 5000, burnin = 10000, n.chains = 4, sample = 10000, thin=250, method='parallel')
save(jags.result.group, file="data/jags-result-group.Rdata")

