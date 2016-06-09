library(plyr)
library(ggplot2)
library(gridExtra)
library(grid)

# load model ####
source('model/dependent-accumulator-model.R')

# set shared params
reps <- 1000
p <- seq(from=0.01,to=0.2,by=0.01)
end <- seq(from=1, to=101,by=2)

results <- expand.grid(p=p,end=end)

run.val <- function(p, end){
  # no boost
  finished.no.boost <- sapply(1:reps, function(x){sum(dependent.accumulators.no.sort(4, p, end, 0)<=25)})
  
  # predict learning time in the one triple condition
  finished.one <- sapply(1:reps, function(x){sum(dependent.accumulators.no.sort(1,p,end,0)<=25)})
  
  # make data frame
  finish.data <- data.frame(condition=c(rep("Four triples - independent", reps), rep("One triple", reps)),
                            finished.count=c(finished.no.boost, finished.one))
  
  finish.data$proportion.correct <- mapply(function(c,f){
    if(c=='One triple'){
      return(.5 + f*.5)
    } else {
      return((1 - f/4)*.5 + f/4 * 1)
    }
  },finish.data$condition,finish.data$finished.count)
  
  finish.data.summary <- ddply(finish.data, .(condition), function(s){
    return(c(m=mean(s$proportion.correct)))
  })
  
  out <- c(finish.data.summary$m[1], finish.data.summary$m[2])
  
  return(out)
}

results[,3:4] <- t(mapply(function(p,end){
  return(run.val(p,end))
}, results$p,results$end))

plot(V3~V4,data=results)
cor.test(~V3+V4,data=results)
