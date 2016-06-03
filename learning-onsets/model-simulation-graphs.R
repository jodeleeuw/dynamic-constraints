library(ggplot2)
library(plyr)
library(tidyr)
source('model/dependent-accumulator-model.R')

#### first plot: finishing distibution for single accumulator ####

params.plot.one <- expand.grid(end=c(1,5,25,100), p=c(0.02,0.04,0.08))
data.plot.one <- ddply(params.plot.one, .(p, end), function(s){
  p <- s$p
  end <- s$end
  reps <- 200000
  max <- 100
  result <- replicate(reps, { return(dependent.accumulators(1,p,end,0)) })
  points <- 1:max
  lk.data <- sapply(points, function(x){ return(sum(result==x)/length(result)) })
  lk.data <- smooth(lk.data)[points]
  df <- data.frame(p=rep(p,max), end=rep(end,max), t=points, y=lk.data)
  return(df)
})

data.plot.one$end <- factor(data.plot.one$end)
data.plot.one$p <- factor(data.plot.one$p, labels=c('\u03bc = 0.02','\u03bc = 0.04','\u03bc = 0.08'))

plot.one <- ggplot(data.plot.one, aes(x=t, y=y, colour=end, fill=end, group=interaction(end,p)))+
  geom_bar(stat='identity', position='identity',alpha=0.3)+
  guides(fill=guide_legend('\u03c3'),colour=guide_legend('\u03C3'))+
  facet_grid(p~.)+
  scale_y_continuous(breaks=c(0,0.1,0.2))+
  labs(x="Finishing time", y="Density",title="A. Single accumulator finishing time distributions")+
  theme_minimal()+
  theme(legend.title=element_text(family='Times New Roman', size=16),
        strip.text=element_text(family='Times New Roman', size=12))

plot.one

#### second plot: finishing distribution with different N of accumulators ####

params.plot.two <- expand.grid(p=c(0.04),end=c(25),n=1:5)
data.plot.two <- ddply(params.plot.two, .(p, end, n), function(s){
  p <- s$p
  end <- s$end
  n <- s$n
  reps <- 200000
  max <- 50
  result <- replicate(reps, { return(dependent.accumulators(n,p,end,boost=0)[[1]]) })
  points <- 1:max
  lk.data <- sapply(points, function(x){ return(sum(result==x)/length(result)) })
  lk.data.smooth <- smooth(lk.data)[points]
  df <- data.frame(p=rep(p,max), end=rep(end,max), n=rep(n,max), t=points, y=lk.data, y.smooth = lk.data.smooth)
  return(df)
})

data.plot.two$n <- factor(data.plot.two$n)
plot.two <- ggplot(data.plot.two, aes(x=t, y=y, colour=n, fill=n, group=n))+
  geom_bar(stat='identity', position='identity', alpha=0.3)+
  labs(x="Finishing time", y="Density",title="B. Finishing time for first of n accumulators")+
  theme_minimal()

plot.two

#### third plot: finishing times with different boosts ####

params.plot.three <- expand.grid(p=c(0.02),end=c(30),n=8,boost=c(0, 0.125, .25, .5, 1, 2))
data.plot.three <- ddply(params.plot.three, .(p,end,n,boost), function(s){
  p <- s$p
  end <- s$end
  n <- s$n
  boost <- s$boost
  reps <- 5000
  result <- replicate(reps, { 
    return(c(0,cumsum(diff(dependent.accumulators(n,p,end,boost=boost)))))
  })
  df <- data.frame(p=rep(p,reps), end=rep(end,reps), n=rep(n,reps), boost=rep(boost,reps), sim=1:reps)
  df <- cbind(df, t(result))
  return(df)
})

data.plot.three <- data.plot.three %>% gather(position, time, 6:(5+(params.plot.three$n)[[1]]))
data.plot.three$boost <- factor(data.plot.three$boost)
plot.three <- ggplot(data.plot.three, aes(x=position,y=time, colour=boost, group=boost))+
  stat_summary(geom='line', fun.y=mean, position=position_dodge(width=0.4))+
  stat_summary(fun.data = function(s){ return(data.frame(y=mean(s),ymin=quantile(s,probs=c(0.0025))[[1]], ymax=quantile(s,probs=c(0.975))[[1]]))}, position = position_dodge(width=0.4))+
  guides(colour=guide_legend('\u03c6'))+
  labs(x="Accumulator", y="Finishing time relative to first accumulator", title="C. Relative finishing times")+
  theme_minimal()+
  theme(legend.title=element_text(family='Times New Roman', size=16))

plot.three

#### fourth plot: changes in p as function of boost ####
data.plot.four  <- expand.grid(p.base=c(0.05), boost=c(0, 0.125, .25, .5, 1, 2), finished=0:30)
data.plot.four$p <- mapply(function(p,boost,finished){
  return(1-(1-p)^(1+boost*finished))
},data.plot.four$p.base, data.plot.four$boost, data.plot.four$finished)
data.plot.four$boost <- factor(data.plot.four$boost)
plot.four <- ggplot(data.plot.four, aes(x=finished,y=p,colour=boost,group=boost))+
  geom_line()+
  geom_point()+
  guides(colour=guide_legend('\u03c6'))+
  labs(x="Number of finished accumulators", title='D. Changes in p as accumulators finish')+
  theme_minimal()+
  theme(legend.title=element_text(family='Times New Roman', size=16))
  

plot.four

#### all together ####
library(grid)
library(gridExtra)

grid.arrange(plot.one, plot.two, plot.three, plot.four)

