library(plyr)
library(ggplot2)
library(gridExtra)
library(grid)

# load model ####
source('model/dependent-accumulator-model.R')

# set shared params
reps <- 1000
p <- rep(0.020, reps)#rbeta(reps, 1, 100)
end <- rep(4, reps)#rpois(reps, 0) + 1
boost <- 50

# predict learning time for W (of NIW triple) in four triple condition
# with boost
finished.boost <- sapply(1:reps, function(x){sum(dependent.accumulators.no.sort(4, p[x], end[x], boost)<=25)})

# no boost
finished.no.boost <- sapply(1:reps, function(x){sum(dependent.accumulators.no.sort(4, p[x], end[x], 0)<=25)})

# predict learning time in the one triple condition
finished.one <- sapply(1:reps, function(x){sum(dependent.accumulators.no.sort(1,p[x],end[x],0)<=25)})

# make data frame
finish.data <- data.frame(condition=c(rep("Four triples - dependent", reps), rep("Four triples - independent", reps), rep("One triple", reps)),
                          finished.count=c(finished.boost, finished.no.boost, finished.one))

finish.data$proportion.correct <- mapply(function(c,f){
  if(c=='One triple'){
    return(.5 + f*.5)
  } else {
    return((1 - f/4)*.5 + f/4 * 1)
  }
},finish.data$condition,finish.data$finished.count)

finish.data.summary <- ddply(finish.data, .(condition), function(s){
  return(c(m=mean(s$proportion.correct), se=(sd(s$proportion.correct)/sqrt(length(s$proportion.correct)))))
})

# empirical data ####
empirical.data <- data.frame(condition=c('Four triples', 'One triple'),
                             mid=c(.733, .59), low=c(0.7,.512), high=c(0.767,.662))

# make plots ####

empirical.plot.2.1 <- ggplot(empirical.data, aes(x=condition, y=mid,ymax=high,ymin=low))+
  geom_pointrange()+
  labs(x="\nExperiment condition", y="Proportion correct\n",title="Experiment 2.1")+
  coord_cartesian(ylim=c(0.5,1.0))+
  theme_minimal()+
  theme(plot.margin=unit(c(1,1,2,1),units="lines"))

model.plot.2.1 <- ggplot(finish.data.summary, aes(x=condition, y=m,ymax=m+se,ymin=m-se))+
  geom_pointrange()+
  labs(x="\nModel", y="",title="Model Results")+
  coord_cartesian(ylim=c(0.5,1.0))+
  theme_minimal()+
  theme(plot.margin=unit(c(1,1,2,1),units="lines"))

grid.arrange(empirical.plot.2.1, model.plot.2.1, nrow=1)

# experiment 2.2 ####

pre.k <- .25

# predict learning time for W (of NIW triple) in four triple condition
# with boost
finished.known <- sapply(1:reps, function(x){sum(dependent.accumulators.pre.knowledge(4, p[x], end[x], boost, c(0,rep(end[x]*pre.k,3)))[1]<=20)})

# no boost
finished.novel <- sapply(1:reps, function(x){sum(dependent.accumulators.pre.knowledge(4, p[x], end[x], boost, c(0,0,0,0))<=20)})

# make data frame
finish.data.2.2 <- data.frame(condition=c(rep("Known words", reps), rep("Novel words", reps)),
                              finished.count=c(finished.known, finished.novel))

finish.data.2.2$proportion.correct <- mapply(function(c,f){
  if(c=='Known words'){
    return(1/6 + f*5/6)
  } else {
    return((1 - f/4)*(1/6) + f/4 * 1)
  }
},finish.data.2.2$condition,finish.data.2.2$finished.count)

finish.data.summary.2.2 <- ddply(finish.data.2.2, .(condition), function(s){
  return(c(m=mean(s$proportion.correct), se=(sd(s$proportion.correct)/sqrt(length(s$proportion.correct)))))
})

# empirical data ####
empirical.data.2.2 <- data.frame(condition=c('Known words', 'Novel words'),
                                 mid=c(.565, .396), low=c(0.458,.344), high=c(0.657,.451))

# make plots ####

empirical.plot.2.2 <- ggplot(empirical.data.2.2, aes(x=condition, y=mid,ymax=high,ymin=low))+
  geom_pointrange()+
  labs(x="\nExperiment condition", y="Proportion correct\n",title="Experiment 2.2")+
  coord_cartesian(ylim=c(0.3,1.0))+
  theme_minimal()+
  theme(plot.margin=unit(c(2,1,1,1),units="lines"))

model.plot.2.2 <- ggplot(finish.data.summary.2.2, aes(x=condition, y=m,ymax=m+se,ymin=m-se))+
  geom_pointrange()+
  labs(x="\nModel", y="",title="Model Results")+
  coord_cartesian(ylim=c(0.3,1.0))+
  theme_minimal()+
  theme(plot.margin=unit(c(2,1,1,1),units="lines"))

grid.arrange(empirical.plot.2.1, model.plot.2.1,empirical.plot.2.2, model.plot.2.2, nrow=2)
