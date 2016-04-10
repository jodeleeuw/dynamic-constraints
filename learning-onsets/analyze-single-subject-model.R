library(ggplot2)
library(plyr)
library(coda)

which.subjects <- c(1)

load('data/jags-result-single-subject-1.Rdata')
m <- as.matrix(as.mcmc.list(jags.result.single.subject),chains=T)
dim(m)

load('data/data-for-jags-single-subject-3.Rdata')

ggplot(data.model.subset, aes(x=t,y=rt,colour=factor(symbol)))+
  geom_line()
