# load required libraries
require(plyr)
require(runjags)
require(coda)
require(ggplot2)
source('lib/DBDA2E-utilities.R')

# load the data
load('data/data-summary.Rdata')
load('data/jags-result-group.Rdata')

# effective chain length. goal is >10,000 for params of interest.
effectiveSize(jags.result.group)

# quick visualization of chains
plot(jags.result.group)

# plot posterior samples from the model ####

# pick a random set of samples from the posterior
n.samples <- 250
jags.posterior.matrix <- as.matrix(as.mcmc.list(jags.result.group),chains=T)
data.posterior.samples <- jags.posterior.matrix[sample(nrow(jags.posterior.matrix), size=n.samples, replace=FALSE),]

# function to generate predicted mean rt from condition, position, and time
model.prediction <- function(row, cond, position, t){
  a <- row['a.base.z'] + row[paste0('a.cond.z[',cond,']')] + row[paste0('a.position.z[',position,']')] + row[paste0('a.cond.position.z[',cond,',',position,']')]
  b <- row['b.base.z'] + row[paste0('b.cond.z[',cond,']')] + row[paste0('b.position.z[',position,']')] + row[paste0('b.cond.position.z[',cond,',',position,']')]
  c <- row['c.base.z'] + row[paste0('c.cond.z[',cond,']')] + row[paste0('c.position.z[',position,']')] + row[paste0('c.cond.position.z[',cond,',',position,']')]
  return( a * (1 + b*(t^(-c) - 1)))
}

# base data frame for computing predicted outcomes
df.base <- expand.grid(cond=1:3, t=1:36, position=1:3)

# empty data frame to fill with posterior predictions
data.posterior.overlay <- data.frame(i=numeric(),t=numeric(),y=numeric(),cond=numeric(),position=numeric())

# iterate over samples and generate predictions
for(i in 1:nrow(data.posterior.samples)){
  r <- data.posterior.samples[i,]
  new.df <- df.base
  new.df$y <- mapply(model.prediction, cond=new.df$cond, t=new.df$t, position=new.df$position, MoreArgs = list(row=r))
  new.df$i <- i
  data.posterior.overlay <- rbind(data.posterior.overlay,new.df)
}

# order the levels of cond for plotting

data.summary$cond <- factor(data.summary$cond, levels=c(1,3,2))
data.posterior.overlay$cond <- factor(data.posterior.overlay$cond, levels=c(1,3,2))

# plot data with posterior samples ####
ggplot(data.summary, aes(x=t,y=rt,colour=cond)) +
  geom_point(alpha = 0.8)+
  geom_line(data=data.posterior.overlay, aes(y=y, group=interaction(i, cond)), alpha=0.1)+
  facet_grid(.~position, labeller = labeller(position=c("1"="N", "2"="I", "3"="W")))+
  labs(title="Response times to N / I / W", x="\nNumber of times the letter has appeared in the sequence",y="RT (ms)\n")+
  scale_colour_hue(name="Context", labels=c("Three Known Words","Three Unknown Words", "Scrambled"))+
  theme_minimal(base_size=18)

# plotting posteriors with HDIs ####
# layout(matrix(1:3,nrow=1))
# plotPost(jags.posterior.matrix[,'a.base.z'],xlab="Baseline - a")
# plotPost(jags.posterior.matrix[,'b.base.z'],xlab="Baseline - b")
# plotPost(jags.posterior.matrix[,'c.base.z'],xlab="Baseline - c")
# 
# layout(matrix(1:9,nrow=3,byrow=T))
# plotPost(jags.posterior.matrix[,'a.cond.z[1]'],xlab="Condition 1 deflection - a")
# plotPost(jags.posterior.matrix[,'a.cond.z[2]'],xlab="Condition 2 deflection - a")
# plotPost(jags.posterior.matrix[,'a.cond.z[3]'],xlab="Condition 3 deflection - a")
# 
# plotPost(jags.posterior.matrix[,'b.cond.z[1]'],xlab="Condition 1 deflection - b")
# plotPost(jags.posterior.matrix[,'b.cond.z[2]'],xlab="Condition 2 deflection - b")
# plotPost(jags.posterior.matrix[,'b.cond.z[3]'],xlab="Condition 3 deflection - b")
# 
# plotPost(jags.posterior.matrix[,'c.cond.z[1]'],xlab="Condition 1 deflection - c")
# plotPost(jags.posterior.matrix[,'c.cond.z[2]'],xlab="Condition 2 deflection - c")
# plotPost(jags.posterior.matrix[,'c.cond.z[3]'],xlab="Condition 3 deflection - c")
# 
# layout(matrix(1:9,nrow=3,byrow=T))
# plotPost(jags.posterior.matrix[,'a.position.z[1]'],xlab="Position 1 deflection - a")
# plotPost(jags.posterior.matrix[,'a.position.z[2]'],xlab="Position 2 deflection - a")
# plotPost(jags.posterior.matrix[,'a.position.z[3]'],xlab="Position 3 deflection - a")
# 
# plotPost(jags.posterior.matrix[,'b.position.z[1]'],xlab="Position 1 deflection - b")
# plotPost(jags.posterior.matrix[,'b.position.z[2]'],xlab="Position 2 deflection - b")
# plotPost(jags.posterior.matrix[,'b.position.z[3]'],xlab="Position 3 deflection - b")
# 
# plotPost(jags.posterior.matrix[,'c.position.z[1]'],xlab="Position 1 deflection - c")
# plotPost(jags.posterior.matrix[,'c.position.z[2]'],xlab="Position 2 deflection - c")
# plotPost(jags.posterior.matrix[,'c.position.z[3]'],xlab="Position 3 deflection - c")

                