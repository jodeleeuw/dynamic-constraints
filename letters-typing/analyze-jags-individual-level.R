# libraries
require(coda)
require(plyr)
require(tidyr)
require(ggplot2)
source('lib/DBDA2E-utilities.R')

# load the jags output & model data
load('data/jags-result-individual.Rdata')
load('data/data-for-individual-model.Rdata')

# effective sample size
effectiveSize(jags.result.individual)

# count subjects
n.subjects <- length(unique(data.for.model$subject))

# pick a random set of samples from the posterior
n.samples <- 25
jags.posterior.matrix <- as.matrix(as.mcmc.list(jags.result.individual),chains=T)
data.posterior.samples <- jags.posterior.matrix[sample(nrow(jags.posterior.matrix), size=n.samples, replace=FALSE),]

# base data frame for computing predicted outcomes
df.base <- expand.grid(subject=1:n.subjects, t=1:36)

# generate the secondary learning curves for each subject
learning.prediction <- function(row, subject, t){
  offset <- row[paste0('offset.W[',subject,']')]
  b.W <- row[paste0('b.W[',subject,']')]
  c.W <- row[paste0('c.W[',subject,']')]
  if(t < offset) { return(0) }
  return(-b.W*(t-offset + 1)^-c.W+b.W)
}

data.learning.curves <- data.frame(subject=numeric(), t=numeric(), y=numeric(), i=numeric())
for(i in 1:nrow(data.posterior.samples)){
  r <- data.posterior.samples[i,]
  new.df <- df.base
  new.df$y <- mapply(learning.prediction, subject = new.df$subject, t=new.df$t, MoreArgs = list(row=r))
  new.df$i <- i
  data.learning.curves <- rbind(data.learning.curves, new.df)
}

# plot ####
layout(1) # reset just in case...
ggplot(data.learning.curves, aes(x=t,y=y,group=i))+
  geom_line()+
  facet_wrap(~subject)

# get HDIs for subject-level params of interest ####
subject.hdi <- expand.grid(subject=1:n.subjects, loc=c('low','high','median'), parameter=c('a.adapt', 'b.adapt','c.adapt', 'item.difference', 'b.W','c.W','offset.W'))
subject.hdi$value <- mapply(function(s,l,p){
  vector <- jags.posterior.matrix[,paste0(p,'[',s,']')]
  # only look at learning curve params when subject is a learner
  if(p %in% c('offset.W', 'b.W','c.W')) {
    islearner <- jags.posterior.matrix[,paste0('is.learner[',s,']')]
    vector <- vector[islearner==1] 
  }
  limits <- HDIofMCMC(vector)
  if(l=='low') { return(limits[1]) }
  if(l=='high') { return(limits[2])}
  if(l=='median') { return(median(vector)) }
},subject.hdi$subject, subject.hdi$loc, subject.hdi$parameter)
subject.hdi <- subject.hdi %>% spread('loc','value')

# looking at subject level params ####
ggplot(subject.hdi, aes(x=subject,ymin=low,ymax=high, y=median))+
  geom_pointrange()+
  facet_wrap(~parameter, scales="free_y")

# plot proportion of time model ####
subject.p.learner <- data.frame(subject=1:n.subjects)
subject.p.learner$p <- sapply(subject.p.learner$subject, function(s){
  vector <- jags.posterior.matrix[,paste0('is.learner[',s,']')]
  return( table(vector)[[1]] / length(vector) )
})
ggplot(subject.p.learner, aes(x=subject, y=p))+
  geom_bar(stat='identity')+
  labs(x="\nSubject", y="Proportion of samples classified as learner\n")+
  theme_minimal(base_size=14)


# plotting subject model data ####

# function to generate predicted mean rt from condition, position, and time
model.prediction <- function(row, subject, t, p){
  a.N <- row[paste0('a.adapt[',subject,',1]')]
  a.W <- row[paste0('a.adapt[',subject,',2]')]
  b <- row[paste0('b.adapt[',subject,']')]
  c <- row[paste0('c.adapt[',subject,']')]
  islearner <- row[paste0('is.learner[',subject,']')]
  offset.W <- row[paste0('offset.W[',subject,']')]
  b.W <- row[paste0('b.W[',subject,']')]
  c.W <- row[paste0('c.W[',subject,']')]
  
  N <- (a.N * (1 + b*(t^-c - 1)))
  if( t < offset.W || islearner == 2) {
    W <- (a.W * (1 + b*(t^-c - 1)))
  } else {
    W <- (a.W * (1 + b*(t^-c - 1))) * (1 + b.W*((t-offset.W+1)^-c.W - 1))
  }
  
  if(p=="rt.W"){
    return(W)
  } else if(p=="rt.N"){
    return(N)
  }
}

# list of subject conditions
subject.conditions <- data.frame(subject=1:n.subjects)
subject.conditions$cond <- sapply(subject.conditions$subject, function(s){
  c <- subset(data.for.model, subject==s)$cond[1]
  return(c)
})

# empty data frame to fill with posterior predictions
data.posterior.overlay <- data.frame(i=numeric(),t=numeric(),y=numeric(),subject=numeric())

model.prediction.base <- expand.grid(subject=1:n.subjects, t=1:36, letter=c('rt.N','rt.W'))
# iterate over samples and generate predictions
for(i in 1:nrow(data.posterior.samples)){
  r <- data.posterior.samples[i,]
  new.df <- model.prediction.base
  new.df$y <- mapply(model.prediction, subject = new.df$subject, t=new.df$t, p=new.df$letter, MoreArgs = list(row=r))
  new.df$i <- i
  data.posterior.overlay <- rbind(data.posterior.overlay,new.df)
}
data.posterior.overlay$cond <- sapply(data.posterior.overlay$subject, function(s){
  c <- subset(subject.conditions, subject==s)$cond
  return(c)
})
data.posterior.overlay$letter <- factor(as.character(data.posterior.overlay$letter), levels=c('rt.W','rt.N'))

data.for.plotting <- data.for.model %>% gather(letter,rt,4:5)
data.for.plotting$letter <- factor(as.character(data.for.plotting$letter), levels=c('rt.W','rt.N'))

n.per.panel <- 20
total.panels <- ceiling(n.subjects/20)
for(i in 1:total.panels){
  subject.subset <- ((i-1)*n.per.panel + 1):(n.per.panel*i)
  p <- ggplot(subset(data.for.plotting, subject %in% subject.subset), aes(x=t,y=rt,colour=interaction(letter,cond)))+
    geom_point(alpha=1)+
    geom_line(data=subset(data.posterior.overlay, subject %in% subject.subset), aes(x=t,y=y,colour=interaction(letter,cond),group=interaction(i,letter)), alpha=0.2)+
    scale_colour_manual(name="Context", labels=c("W - Three known words", "N - Three known words", "W - Three unknown words", "N - Three unknown words",  "W - Scrambled", "N - Scrambled"), values=c('#a50f15','#fcae91','#006d2c','#bae4b3','#08519c','#bdd7e7'))+
    labs(x="\nNumber of times the letter has appeared in the sequence", y="RT (ms)\n", title="Response times to N and W")+
    facet_wrap(~subject)+
    theme_minimal()
  print(p)
}

# plot HDIs for conditions ####
layout(matrix(1:6, ncol=2))
plotPost(jags.posterior.matrix[,'learner.cond[1]'],xlab="Three known words",xlim=c(0,1))
plotPost(jags.posterior.matrix[,'learner.cond[2]'],xlab="Three unknown words",xlim=c(0,1))
plotPost(jags.posterior.matrix[,'learner.cond[3]'],xlab="Scrambled",xlim=c(0,1))
plotPost(jags.posterior.matrix[,'offset.mode[1]'],xlab="Three known words",xlim=c(0,36))
plotPost(jags.posterior.matrix[,'offset.mode[2]'],xlab="Three unknown words",xlim=c(0,36))
plotPost(jags.posterior.matrix[,'offset.mode[3]'],xlab="Scrambled",xlim=c(0,36))

# plot HDIs for group parameters ####
#layout(1:2)
plotPost(jags.posterior.matrix[,'b.W.group.mode'])
plotPost(jags.posterior.matrix[,'b.W.group.concentration'])
