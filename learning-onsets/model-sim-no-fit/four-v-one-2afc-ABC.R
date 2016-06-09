library(plyr)
library(ggplot2)
library(gridExtra)
library(grid)
library(EasyABC)

# load model ####
source('model/dependent-accumulator-model.R')

# set shared params
reps <- 100

# empirical data
data = c(.733, .590, .565, .396)

model <- function(params){

  p <- max(params[1],0.000000001)
  end <- round(params[2])
  boost <- params[3]
  pre.k <- min(max(params[4],0),1)
  
  # with boost
  finished.boost <- sapply(1:reps, function(x){sum(dependent.accumulators.with.boundary(4, p, end, boost, c(0,0,0,0), 20) > 0)})
  
  # predict learning time in the one triple condition
  finished.one <- sapply(1:reps, function(x){sum(dependent.accumulators.with.boundary(1, p, end, 0, c(0,0,0,0), 20) > 0)})
  
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
  
  #return(rmse)
  
  return(prediction)
}

#x <- seq(from=100,to=5000,by=100)
#y <- sapply(x, function(r){return(model(c(0.02,6,50,.5),r))})
#plot(x,y)

prior <- function(){
  return(
    c(
      rbeta(1,1,20),
      rpois(1,5),
      runif(1,1,250),
      runif(1,0,1)
    )
  )
}

d.prior <- function(params){
  return(
    prod(
      dbeta(params[1],1,20),
      dpois(params[2],5),
      dunif(params[3],1,250),
      dunif(params[4],0,1)
    )
  )
}

#result <- SABC(model, prior, d.prior, n.sample=100, eps.init = 1.8, iter.max=1000, verbose=1, method="informative")

shifted.neg.binom.r <- function(disp,mu){
  return(rnbinom(1,disp,mu=mu)+1)
}

shifted.neg.binom.d <- function(x, disp, mu){
  x <- x - 1
  return(dnbinom(x,disp,mu=mu))
}

prior = list(
  list(c('rbeta',1,1,20), c('dbeta',1,20)),
  list(c('shifted.neg.binom.r',2,20), c('shifted.neg.binom.d',2,20)),
  list(c('rexp',1,1/100), c('dexp',1/100)),
  list(c('runif',1,0,1), c('dunif',0,1))
)

r.prior <- function(){
  return(
    c(
      rbeta(1,1,20),
      shifted.neg.binom.r(2,20),
      rexp(1,1/100),
      runif(1,0,1)
    )
  )
}

d.prior <- function(params){
  return(
    prod(
      dbeta(params[1],1,20),
      shifted.neg.binom.d(round(params[2]),2,20),
      dexp(params[3],1/100),
      dunif(params[4],0,1)
    )
  )
}

result <- ABC_rejection(model, prior, nb_simul = 100000, summary_stat_target = data, tol=0.01,progress_bar = T)

layout(matrix(1:4,nrow=2))
hist(result$param[,1], breaks=50)
hist(result$param[,2], breaks=50)
hist(result$param[,3], breaks=50)
hist(result$param[,4], breaks=50)

result.mcmc <- ABC_mcmc(method='Marjoram', model=model, prior=prior, summary_stat_target = data, progress_bar=T)

result.sabc <- SABC(model,r.prior,d.prior, y=data,n.sample=1000, eps.init=1,iter.max=20000, method='informative', verbose=100)

?optim

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
