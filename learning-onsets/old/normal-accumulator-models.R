# every trial is norm 1, 1

v <- replicate(10000, {
  s <- 0
  for(i in 1:10){
    s <- s + rnorm(1,mean=1,sd=3)
  }
  return(s)
})

x <- rnorm(10000, mean=10, sd=sqrt(9*10))

layout(1:2)
hist(v, xlim=c(-50,50))
hist(x, xlim=c(-50,50))

#### accumulator models ####

dependent.race <- function(n, rate=0.1, noise=0.05, boost.factor=1, end=1){
  accumulators <- rep(0,n)
  finish.times <- rep(Inf,n)
  finished.count <- 0
  t <- 0
  while(finished.count < n){
    t <- t + 1
    accumulators <- accumulators + rnorm(n, mean = rate + finished.count*boost.factor*rate , sd = noise)
    finish.times <- mapply(function(a,f){
      if(a >= end && t < f){
        return(t)
      } else {
        return(f)
      }
    }, accumulators, finish.times)
    finished.count <- sum(finish.times < Inf)
  }
  return(sort(finish.times))
}

p.this.trial <- function(r, end=1, noise=0.05){
  p.prev <- 0
  for(t in 1:length(r)){
    p <- pnorm(end, mean=sum(r[1:t]),sd = sqrt(noise^2*t), lower.tail = F)
    p.diff <- p - p.prev
    p.prev <- p.prev + p.diff
  }
  return(p.diff)
}

log.likelihood <- function(when.learning, rate = 0.1, noise = 0.05, boost = 1, end = 1){
  
  learning.trials <- c(when.learning[1], diff(when.learning))
  rate.trials <- sapply(1:length(when.learning), function(s){ return(rate + (sum(when.learning < when.learning[s]))*boost*rate)})
  print(rate.trials)
  running.accumulators <- length(when.learning):1
  print(running.accumulators)
  
  p.individual <- numeric()
  p.total <- 0
  for(i in 1:length(when.learning)){
    
    rates <- numeric()
    for(j in 1:i){
      rates <- c(rates,rep(rate.trials[j], learning.trials[j]))
    }
    print(rates)
    p <- p.this.trial(rates, end=end,noise=noise)
    
    p.any <- 1 - (1 - p)^running.accumulators[i]
    print(p.any)
    
    p.individual[i] <- log(p.any)
    p.total <- p.total + log(p.any)
  }
  
  return(list(
    p.total=p.total,
    p.individual.events=p.individual
  ))
}

log.likelihood(c(10,13))

plot(1:100, sapply(1:100, function(x){return(p.this.trial(rep(0.05,x), noise=0.2))}))

sim.result <- t(replicate(1000000, {
  return(dependent.race(2, rate = 0.05, noise=0.2, boost.factor = 4))
}))
layout(1)
plot(sim.result[,1], sim.result[,2])


hist(sim.result[,1], breaks=1:200, xlim=c(0,50))
points(1:50, 1000000 * sapply(1:50, function(x){ return(exp(log.likelihood(c(x, x+5), rate=0.05,noise=0.2,boost=4)$p.individual.events[[1]]))}))


sim.result.1acc <- t(replicate(1000000, {
  return(dependent.race(1, rate = 0.05, noise=0.2, boost.factor = 4))
}))
hist(sim.result.1acc[,1], breaks=1:400, xlim=c(0,50))
points(1:50, 1000000 * sapply(1:50, function(x){ return(exp(log.likelihood(x, rate=0.05, noise=0.2,boost=4)$p.individual.events[[1]]))}))
points(1:50, 1000000 * sapply(1:50, function(x){ return(p.this.trial(rep(0.05,x), noise=0.2))}))
points(1:50, 1000000 * sapply(1:50, function(x){ return(dinvgauss(x, mean=1 / 0.05, shape=1/0.2^2 ))     }))
