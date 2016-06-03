#### import model scripts and libraries####
library(ggplot2)
library(plyr)
source('model/dependent-accumulator-model.R')
source('empirical-distributions/recover-distribution.R')

#### get list of empirical distributions ####
path.empirical.distributions <- 'empirical-distributions/model-recovery-distributions/'
all.param.vals <- paste0(path.empirical.distributions, list.files(path.empirical.distributions))

#### function for getting posterior & likelihood over all empirical distributions ####
# assumes that the prior on discrete distributions is uniform - all models equally likely.
posterior <- function(data, distributions){
  result <- data.frame(p=numeric(),end=numeric(),boost=numeric(),likelihood=numeric())
  prior.val <- 1 / length(distributions)
  pb <- txtProgressBar(min=0,max=length(distributions),style=3)
  for(i in distributions){
    l <- log.likelihood.from.json(data, i, min.likelihood = 1e-12)
    result <- rbind(result,l)
    setTxtProgressBar(pb,nrow(result))
  }
  close(pb)
  # find likelihood in original scale
  result$likelihood <- exp(result$log.likelihood)
  
  # find posterior in original scale
  # p.d <- sum(result$likelihood * prior.val)
  # result$posterior <- result$likelihood * prior.val / p.d
  
  # find posterior in original scale via log
  prior.x.likelihood.log <- result$log.likelihood + log(prior.val)
  max.v <- max(prior.x.likelihood.log)
  p.mid <- exp(prior.x.likelihood.log - max.v)
  p.d <- sum(p.mid)
  result$posterior <- p.mid / p.d
  return(result)
}

#### generate data and recover params ####

data <- dependent.accumulators(4, 0.1, 11, .5)

recovery <- posterior(data, all.param.vals)

marginal.posterior.p <- ddply(recovery, .(p), function(s){
  return(c(posterior=sum(s$posterior)))
})

marginal.posterior.end <- ddply(recovery, .(end), function(s){
  return(c(posterior=sum(s$posterior)))
})

marginal.posterior.boost <- ddply(recovery, .(boost), function(s){
  return(c(posterior=sum(s$posterior)))
})

ggplot(marginal.posterior.p, aes(x=p, y=posterior))+
  geom_point()

ggplot(marginal.posterior.end, aes(x=end, y=posterior))+
  geom_point()

ggplot(marginal.posterior.boost, aes(x=boost, y=posterior))+
  geom_point()

#### scaling up to multiple subjects ####

data.10 <- t(replicate(10, {dependent.accumulators(4, 0.03, 3, 1.5)}))

# try exculding subjects who don't finish on time
keep <- apply(data.10,1,function(s){
  return(all(s < 73))
})

data.10.filter <- data.10[keep,]

recovery.10 <- posterior(data.10.filter, all.param.vals)

marginal.posterior.p.10 <- ddply(recovery.10, .(p), function(s){
  return(c(posterior=sum(s$posterior)))
})

marginal.posterior.end.10 <- ddply(recovery.10, .(end), function(s){
  return(c(posterior=sum(s$posterior)))
})

marginal.posterior.boost.10 <- ddply(recovery.10, .(boost), function(s){
  return(c(posterior=sum(s$posterior)))
})

ggplot(marginal.posterior.p.10, aes(x=p, y=posterior))+
  geom_point()

ggplot(marginal.posterior.end.10, aes(x=end, y=posterior))+
  geom_point()

ggplot(marginal.posterior.boost.10, aes(x=boost, y=posterior))+
  geom_point()
