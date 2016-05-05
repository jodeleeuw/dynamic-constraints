# load required libraries
require(plyr)
require(coda)
require(ggplot2)
library(tidyr)
library(emdbook)
source('lib/DBDA2E-utilities.R')

# load the data
load('data/data-summary.Rdata')
load('data/jags-result-group.Rdata')

# effective chain length. goal is >10,000 for params of interest.
#effectiveSize(jags.result.group)
#gelman.diag(jags.result.group)

# quick visualization of chains
#plot(jags.result.group)

# plot posterior samples from the model ####

# pick a random set of samples from the posterior
n.samples <- 100
jags.posterior.matrix <- as.matrix(as.mcmc.list(jags.result.group),chains=T)
data.posterior.samples <- jags.posterior.matrix[sample(nrow(jags.posterior.matrix), size=n.samples, replace=FALSE),]

# function to generate predicted mean rt from condition, position, and time
model.prediction <- function(row, cond, position, t){
  a <- row[paste0('a.cond.position[',cond,',',position,']')]
  b <- row[paste0('b.cond.position[',cond,',',position,']')]
  c <- row[paste0('c.cond.position[',cond,',',position,']')]
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
  geom_point(alpha = 1.0)+
  geom_line(data=data.posterior.overlay, aes(y=y, group=interaction(i, cond)), alpha=0.1)+
  facet_grid(.~position, labeller = labeller(position=c("1"="N", "2"="I", "3"="W")))+
  labs(title="Response times to N / I / W", x="\nNumber of times the letter has appeared in the sequence",y="RT (ms)\n")+
  scale_colour_hue(name="Context", labels=c("Known Words","Novel Words", "Scrambled"))+
  theme_minimal(base_size=18)

# plotting b/c join density for each position

jags.posterior.df <- as.data.frame(jags.posterior.matrix)
jags.posterior.df$CHAIN <- NULL
jags.posterior.df$a.overall.mode <- NULL
jags.posterior.df$a.overall.sd <- NULL
jags.posterior.df$b.overall.mode <- NULL
jags.posterior.df$b.overall.concentration <- NULL
jags.posterior.df$c.overall.sd <- NULL
jags.posterior.df$c.overall.mode <- NULL
jags.posterior.df$sd.rt <- NULL
jags.posterior.df$sample <- 1:nrow(jags.posterior.df)

jags.posterior.tidy <- jags.posterior.df %>% gather(key, value, -sample) %>% separate(key, c('parameter','cp'), sep=1) %>% separate(cp, c('cond', 'position'), sep=-3)
jags.posterior.tidy$cond <- gsub("[^0-9]","",jags.posterior.tidy$cond)
jags.posterior.tidy$position <- gsub("[^0-9]","",jags.posterior.tidy$position)
jags.posterior.tidy <- jags.posterior.tidy %>% spread(parameter, value)

hdr.95 <- ddply(subset(jags.posterior.tidy,T,c('position','cond','b','c')), .(position, cond), function(s){
  contour.lines <- as.data.frame(HPDregionplot(mcmc(data.matrix(s[,c('b','c')])), prob=0.95))
  return(data.frame(position=rep(s$position[1],nrow(contour.lines)), cond=rep(s$cond[1],nrow(contour.lines)),x=contour.lines$x, y=contour.lines$y))
})

hdr.95$cond <- factor(hdr.95$cond, levels=c(1,3,2))

ggplot(hdr.95, aes(x=x, y=y, fill=cond)) +
  geom_polygon(alpha=0.6)+
  facet_grid(.~position, labeller = labeller(position=c("1"="N", "2"="I", "3"="W")))+
  labs(title="Parameter estimates for N / I / W", x="\nb",y="c\n")+
  scale_fill_hue(name="Context",labels=c("Known Words","Novel Words", "Scrambled"))+
  theme_minimal(base_size = 18)
