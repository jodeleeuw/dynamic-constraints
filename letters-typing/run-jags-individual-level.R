# analysis options
# subset.data - TRUE to run the JAGS model on only some subjects for faster MCMC sampling during development
# subset.amount - # of subjects to include if subset.data = T
subset.data <- F
subset.amount <- 15

# libraries
require(plyr)
require(runjags)
require(tidyr)

# load the data
data.all <- read.csv('data/filtered-data.csv')

# get only the data from test trials
data.test <- subset(data.all, practice == 0)

# add a column that indicates how many times a letter has appeared in the experiment
n_subjects <- length(unique(data.test$subject))
data.test$appearanceCount <- rep(as.vector(sapply(1:36, function(x){return(rep(x,12))})), n_subjects)

# get subset of data for the model
data.for.model <- subset(data.test, correct==1 & triple_type == 'critical' & triple_position%in%c(1,3), c('subject','cond','appearanceCount','triple_position','rt'))

# one subject (13266) did not record a single correct response
# i missed this the first time through which messed up the ordering of subject numbers for the explicit debrief data
# this is just some code to fix that order post-hoc
subject.id <- data.frame(original=unique(data.test$subject))
subject.id$original.numeric <- as.numeric(factor(subject.id$original))

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

# run the jags model ####

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
jags.result.individual <- run.jags('jags-models/individual-level.txt', data=data.model, monitor = parameters, n.chains=4, burnin=10000, sample=5000, thin=2, method='parallel')
save(jags.result.individual, file="data/jags-result-individual.Rdata")
