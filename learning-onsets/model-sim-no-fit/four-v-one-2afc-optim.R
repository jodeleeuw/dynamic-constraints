library(plyr)
library(ggplot2)
library(gridExtra)
library(grid)
library(DEoptim)

# load model ####
source('model/dependent-accumulator-model.R')

# set shared params
reps <- 1000

# empirical data
data = c(.733, .590, .565, .396)

model <- function(params){

  p <- max(params[1],0.000000001)
  end <- round(params[2])
  boost <- params[3]
  pre.k <- min(max(params[4],0),1)
  
  # with boost
  finished.boost <- sapply(1:reps, function(x){sum(dependent.accumulators.with.boundary(4, p, end, boost, c(0,0,0,0), 25) > 0)})
  
  # predict learning time in the one triple condition
  finished.one   <- sapply(1:reps, function(x){sum(dependent.accumulators.with.boundary(1, p, end, 0, c(0,0,0,0), 25) > 0)})
  
  # with boost
  finished.known <- sapply(1:reps, function(x){sum(dependent.accumulators.with.boundary(4, p, end, boost, c(0,rep(floor(end*pre.k),3)), 20)[1] > 0)})
  
  # no boost
  finished.novel <- sapply(1:reps, function(x){sum(dependent.accumulators.with.boundary(4, p, end, boost, c(0,0,0,0), 20) > 0)})
  
  prediction = c(
    mean((1-finished.boost/4)*.5 + (finished.boost/4)),
    mean(finished.one*.5 + .5),
    mean(finished.known*5/6 + 1/6),
    mean(finished.novel/4 + (1-finished.novel/4)* 1/6)
  )
  
  rmse = sum(sqrt( (prediction-data)^2 ))
  
  return(rmse)
  
  #return(prediction)
}

model(c(0.02,4,50,0.25))

#x <- seq(from=100,to=5000,by=100)
#y <- sapply(x, function(r){return(model(c(0.02,6,50,.5),r))})
#plot(x,y)

result <- DEoptim(model, lower=c(0.00001,1,0,0), upper=c(1,1000,500,1))
# make plots ####
# 
# empirical.plot.2.2 <- ggplot(empirical.data.2.2, aes(x=condition, y=mid,ymax=high,ymin=low))+
#   geom_pointrange()+
#   labs(x="\nExperiment condition", y="Proportion correct\n",title="Experiment 2.2")+
#   coord_cartesian(ylim=c(0.3,1.0))+
#   theme_minimal()+
#   theme(plot.margin=unit(c(2,1,1,1),units="lines"))
# 
# model.plot.2.2 <- ggplot(finish.data.summary.2.2, aes(x=condition, y=m,ymax=m+se,ymin=m-se))+
#   geom_pointrange()+
#   labs(x="\nModel", y="",title="Model Results")+
#   coord_cartesian(ylim=c(0.3,1.0))+
#   theme_minimal()+
#   theme(plot.margin=unit(c(2,1,1,1),units="lines"))
# 
# grid.arrange(empirical.plot.2.1, model.plot.2.1,empirical.plot.2.2, model.plot.2.2, nrow=2)
