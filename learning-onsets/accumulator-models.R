run.simulations <- F

## simulate the model

dependent.race <- function(n, p.success=0.05, end=100, boost=1){
  accumulators <- rep(0,n)
  finish.times <- rep(Inf,n)
  finished.count <- 0
  t <- 0
  while(finished.count < n){
    t <- t + 1
    p <- 1 - (1 - p.success)^(1 + boost * finished.count)
    accumulators <- accumulators + rbinom(n, end, p)
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

dependent.race.accumulator.states <- function(n, p.success=0.05, end=100, boost=1){
  accumulators <- rep(0,n)
  finish.times <- rep(Inf,n)
  finished.count <- 0
  state.matrix <- accumulators
  t <- 0
  while(finished.count < n){
    t <- t + 1
    p <- 1 - (1 - p.success)^(1 + boost * finished.count)
    accumulators <- accumulators + rbinom(n, end, p)
    state.matrix <- rbind(state.matrix, accumulators)
    finish.times <- mapply(function(a,f){
      if(a >= end && t < f){
        return(t)
      } else {
        return(f)
      }
    }, accumulators, finish.times)
    finished.count <- sum(finish.times < Inf)
  }
  o <- order(finish.times)
  m.out <- state.matrix
  for(i in 1:length(finish.times)){
    m.out[,i] <- state.matrix[,o[i]]
  }
  row.names(m.out) <- NULL
  m.out <- m.out[-1,]
  return(m.out)
}

## likelihood function ####

# explicitly combine two probability distributions, expecting a vector of 
# probabilities (first element = count 0)
# from: http://math.stackexchange.com/a/257812/336665
combine.distributions <- function(a, b) {
  
  # because of the following computation, make a matrix with more columns than rows
  if (length(a) < length(b)) {
    t <- a
    a <- b
    b <- t
  }
  
  # explicitly multiply the probability distributions
  m <- a %*% t(b)
  
  # initialized the final result, element 1 = count 0
  result <- rep(0, length(a)+length(b)-1)
  
  # add the probabilities, always adding to the next subsequent slice
  # of the result vector
  for (i in 1:nrow(m)) {
    result[i:(ncol(m)+i-1)] <- result[i:(ncol(m)+i-1)] + m[i,]
  }
  
  return(result)
}

# target is the number of successes needed
# p is the vector of p(success) for each trial, including the last trial
# n.parallel is the number of accumulators running for this trial
# last.finish.time is when anything before this accumulator boundary
likelihood.this.trial <- function(target, p, n.parallel, last.finish.time, n.finished.same.time=0){
  
  # first find the vector of p's where we know that the accumulator is below target.
  # this is everything up to the trial right before the last accumulator finished 
  # (b/c it's possible that both accumulators finish at the same time)
  # the probability of this accumulator finishing in that time is 0, because
  # the accumulators are ordered by finishing times.
  if(!missing(last.finish.time) && last.finish.time > 1){
    state <- state.probability(target, p[1:last.finish.time-1])
  } else {
    state <- c(1) # prob of 0 accumulation, indexed at state[1], is 1 at the start of the simulation
  }
  
  # now get the vector of p's where learning is possible
  if(missing(last.finish.time)){
    p.possible <- p
  } else {
    p.possible <- p[last.finish.time:length(p)]
  }
  
  # if there is only one item in p.possible, then it is the target trial.
  # state is the density before learning.
  # we have to account for the possibility that the another accumulator (or many other accumulators)
  # finished on this trial. if an "earlier" accumulator finished on this trial too,
  # then the p(finishing) is the JOINT probability of both accumulators finishing on this trial. otherwise,
  # this accumulator would have been in the other slot.
  if(length(p.possible)==1){
    likelihood <- dbinom(0:target, target, p.possible[[1]])
    likelihood <- combine.distributions(likelihood, state)
    before.trial <- 0
    after.trial.single.accumulator <- 1 - sum(likelihood[1:target])
    after.trial <- 1 - pbinom(n.finished.same.time, n.parallel, after.trial.single.accumulator)
  } else {
    # otherwise, separate out the before and after learning portions
    p.before.this.trial <- p.possible[1:(length(p.possible)-1)]
    
    # there should be only one value of p in this vector, so it's length is the number of trials
    likelihood.before <- dbinom(0:(target*length(p.before.this.trial)), target*length(p.before.this.trial), p.before.this.trial[1])
    if(exists("state")){
      likelihood.before <- combine.distributions(likelihood.before, state)
    }
    likelihood.after <- combine.distributions(likelihood.before, dbinom(0:target, target, p[length(p)]))
    before.trial <- 1 - (1 - (1 - sum(likelihood.before[1:target])))^n.parallel
    after.trial <- 1 - (1 - (1 - sum(likelihood.after[1:target])))^n.parallel
  }
  
  # if(length(p)>1){
  #   p.vec.before <- p[1:(length(p)-1)]
  #   p.rle <- rle(p.vec.before)
  #   n.rle <- rle(n.parallel)
  #   
  #   if(length(n.rle$lengths) == 1){
  #     likelihood <- dbinom(0:(target*p.rle$lengths[[1]]), target*p.rle$lengths[[1]], p.rle$values[[1]])
  #   } else {
  #     p.no.learn <- p.vec.before[p.vec.before!=p.rel$values[[length(p.rel$values)]]]
  #     state <- state.probability(target, p.no.learn)
  #     likelihood <- combine.distributions(state, dbinom(0:(target*p.rle$lengths[[length(p.rel$values)]]), target*p.rle$lengths[[length(p.rel$values)]], p.rle$values[[length(p.rel$values)]]))
  #   }
  #   before.trial <- 1 - (1 - (1 - sum(likelihood[1:target])))^n.parallel # sum is outcomes of 0 to target-1
  #   
  #   likelihood <- combine.distributions(likelihood, dbinom(0:target, target, p[length(p)]))
  #   after.trial <- 1 - (1 - (1 - sum(likelihood[1:target])))^n.parallel
  # } else {
  #   before.trial <- 0
  #   after.trial <- 1 - (1 - (1 - sum(likelihood[1:target])))^n.parallel
  # }
  
  p.this.trial <- after.trial - before.trial

  return(p.this.trial)
}

# compute the probability of each accumulator state for a single accumulator
# given that the target has not yet been reached
state.probability <- function(target, p){
  
  for(i in 1:length(p)){
    l <- dbinom(0:target, target, p[i])
    if(exists('state')){
      state <- combine.distributions(state, l)
    } else {
      state <- l
    }
    state <- state[1:target] / sum(state[1:target])
  }
  
  return(state)
  
}

log.likelihood <- function(t, p.success=0.05, end=100, boost=1){
  
  learning.trials <- c(t[1], diff(t))
  n.accumulators <- length(t):1
  p.trials <- sapply(1:length(t), function(s){ return(1 - (1 - p.success)^(1 + boost * (sum(t < t[s]))))})
  p.seq <- rep(p.trials, learning.trials)
  n.acc.seq <- rep(n.accumulators, learning.trials)
  simultaneous.finish <- sapply(1:length(t), function(s) { return(sum(t[1:s]==t[s])-1)})
  
  p.total <- 0
  p.individual <- numeric()
  for(i in 1:length(t)){
    if(i > 1) {
      last.finish <- t[i-1]
      p <- likelihood.this.trial(end, p.seq[1:t[i]], n.acc.seq[t[i]], last.finish, simultaneous.finish[i])
    } else {
      p <- likelihood.this.trial(end, p.seq[1:t[i]], n.acc.seq[t[i]])
    }
    p.total <- p.total + log(p)
    p.individual <- c(p.individual, log(p))
  }
  return(list(
    total=p.total,
    individual=p.individual
  ))
}

# testing ####

log.likelihood(c(18,18),boost=0)

# 1 racer ####
# if(run.simulations){
#   sim.result <- replicate(50000, {
#     return(dependent.race(1, boost = 0))
#   })
# }
# 
# hist(sim.result, xlim=c(10,30))
# points(10:30, 50000*sapply(10:30, function(x){return(exp(log.likelihood(x, boost=0)$total))}))
# 
# sum(sim.result==22) / 50000
# exp(log.likelihood(22, boost=0)$total)
# 
# # 2 racers ####
# n.sims.2 <- 250000
# if(run.simulations){
#   sim.result.2 <- t(replicate(n.sims.2, {
#     return(dependent.race(2, boost = 0))
#   }))
# }
# 
# hist(sim.result.2[,1], xlim=c(10,30))
# points(10:30, n.sims.2*sapply(10:30, function(x){return(exp(log.likelihood(c(x,x+5), boost=0)$individual[[1]]))}))
# 
# sim.conditional <- sim.result.2[sim.result.2[,1]==18,2]
# hist(sim.conditional, xlim=c(17,30), breaks=17:32)
# points(18:30, length(sim.conditional)*sapply(18:30, function(x){return(exp(log.likelihood(c(18,x), boost=0)$individual[[2]]))}))
# 
# nrow(sim.result.2[sim.result.2[,1]==19 & sim.result.2[,2]==24,]) / n.sims.2
# exp(log.likelihood(c(19,24), boost=0)$total)

# accumulator states
 n.sims.3 <- 100000
 sim.result.3 <- replicate(n.sims.3, {
   return(dependent.race.accumulator.states(2, boost=0))
 })
 
 select.set <- function(set, finish.times, target, which.acc, t){
   result <- numeric()
   for(i in 1:length(set)){
     is.match <- T
     if(length(finish.times)>0){
       for(j in 1:length(finish.times)){
         f <- min(which(set[[i]][,j] >= target))
         if(f!=finish.times[j]){
           is.match <- F
         }
       }
     }
     if(is.match){
       acc <- set[[i]][,which.acc]
       if(length(acc) >= t){
         result <- c(result, set[[i]][t, which.acc])
       }
     }
   }
   return(result)
 }
 
 x <- select.set(sim.result.3, c(), 100, c(1,2), 5)
 hist(x, breaks=1:100)
 points(10:40, length(x)*dbinom(10:40, 100*5, 0.05))

