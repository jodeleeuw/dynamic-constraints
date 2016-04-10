# load required packages
require(plyr)
require(runjags)
require(coda)

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

save(data.summary, file='data/data-group-level.Rdata')

data.model <- as.list(data.summary)
data.model$ndata <- nrow(data.summary)

# run the model ####

monitor.parameters <- c(
  'a.cond.position','b.cond.position','c.cond.position',
  'a.overall.mode','a.overall.sd','b.overall.mode','b.overall.concentration',
  'c.overall.mode','c.overall.sd',
  'sd.rt'
)

jags.result.group <- run.jags('jags-models/group-level.txt', monitor=monitor.parameters, data=data.model, adapt = 5000, burnin = 10000, n.chains = 4, sample = 10500, thin=500, method='parallel')
save(jags.result.group, file="data/jags-result-group.Rdata")
