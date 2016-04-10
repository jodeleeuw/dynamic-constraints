
subset.data <- T
subset.amount <- 1

library(plyr)
library(tidyr)
library(runjags)

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
data.for.model <- subset(data.test, correct==1 & triple_position%in%c(1,3), c('subject','appearanceCount','stimulus', 'rt'))

# create column that index which letter is being tested in a specific way
# unpredictable elements are 1-4, predictable 5-8
data.for.model$symbol <- as.numeric(factor(as.character(data.for.model$stimulus), levels=c('N','T','R','Y','W','C','H','D')))
data.for.model$symbol.type <- as.numeric(data.for.model$symbol > 4) + 1

# get data in right format
data.for.model$subject <- as.numeric(factor(data.for.model$subject))
data.for.model$stimulus <- NULL
colnames(data.for.model) <- c('subject', 't', 'rt','symbol','symbol.type')

#save(data.for.model, file="data/data-for-individual-model.Rdata")

# HARD CODING IN SUBJECT LIMIT OF 1 FOR NOW...
which.subject <- 3
data.model.subset <- subset(data.for.model, subject==which.subject)
data.jags <- as.list(data.model.subset)
data.jags$ndata <- nrow(data.model.subset)
save(data.model.subset, file=paste0("data/data-for-jags-single-subject-",which.subject,".Rdata"))

# run the jags model ####
parameters <- c('a.adapt','b.adapt','c.adapt','b','c','offset','b.pseudo','c.pseudo','sd.rt')
jags.result.single.subject <- run.jags('jags-models/single-subject-model.txt',data=data.jags, monitor=parameters, adapt=1000,burnin=1000,sample=10000,n.chains=4)
save(jags.result.single.subject, file=paste0("data/jags-result-single-subject-",which.subject,".Rdata"))


