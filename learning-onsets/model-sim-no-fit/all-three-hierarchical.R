library(plyr)
library(ggplot2)
library(gridExtra)
library(grid)

# load model ####
source('model/dependent-accumulator-model.R')

# set shared params
reps <- 20000
m <- sample(c(0.001, 0.020), reps, replace=T, prob=c(0.8,0.2))
k <- 300
a <- m*(k-2)+1
b <- (1-m)*(k-2)+1
p <- rbeta(reps, a,b)
hist(p, breaks=100)
end <- rpois(reps, 2) + 1
boost <- 50
pre.k <- 3/4


# predict learning time for W (of NIW triple) in four triple condition
# with boost
f.times.four.known <- sapply(1:reps, function(x){dependent.accumulators.pre.knowledge(4, p[x], end[x], boost, c(0,rep(end[x]*pre.k,3)))[[1]]})

# no boost
f.times.four.unknown <- sapply(1:reps, function(x){dependent.accumulators.pre.knowledge(4, p[x], end[x], boost, c(0, 0, 0, 0))[[1]]})

# predict learning time in the one triple condition
f.times.one <- sapply(1:reps, function(x){dependent.accumulators.pre.knowledge(1,p[x],end[x],0, c(0))[[1]]})

# make data frame
finish.data <- data.frame(condition=c(rep("Four triples - known", reps), rep("Four triples - unknown", reps), rep("One triple", reps)),
                          finish.time=c(f.times.four.known, f.times.four.unknown, f.times.one))

finish.data.summary <- ddply(finish.data, .(condition), function(s){
  in.time <- s$finish.time[s$finish.time <= 72]
  m <- mean(in.time)
  se <- sd(in.time) / sqrt(length(in.time))
  p.learn <- length(in.time) / nrow(s)
  return(c(m=m,se=se,p.learn=p.learn))
})

# empirical data ####
empirical.data <- data.frame(condition = c('Four triples - known', 'Four triples - unknown', 'One triple'),
                             onset.mid = c(18.1,29.3,40.1), onset.low = c(16.9,26.8,36.2), onset.high = c(19.6,31.6,44.7),
                             proportion.mid = c(0.717,0.304,0.179), proportion.low = c(0.579, 0.207, 0.0976), proportion.high = c(0.845, 0.431, 0.285))


# make plots ####
max.val <- max(finish.data$finish.time)+1

histograms <- ggplot(finish.data, aes(x=finish.time, fill=condition))+
  geom_histogram(alpha=0.6, position = 'identity', bins=101)+
  geom_vline(xintercept = 72)+
  theme_minimal()+
  labs(x="Accumulator finish time", y="Frequency",fill="Condition",title="Learning onset for target triple")+
  scale_x_continuous(limits=c(0,100))+
  theme(axis.text.y=element_blank())

mean.se <- ggplot(finish.data.summary, aes(x=condition, colour=condition, y=m, ymax=m+1.96*se, ymin=m-1.96*se))+
  geom_point(shape=108,size=10)+
  geom_pointrange(data=empirical.data, colour='black', aes(y=onset.mid, ymax=onset.high, ymin=onset.low))+
  scale_y_continuous(limits=c(0,72))+
  labs(y="Learning onset", x="",title="Mean onset of learning for subjects who learned")+
  coord_flip()+
  scale_color_hue(guide=F)+
  theme_minimal()+
  theme(axis.text.y=element_blank(), plot.margin=unit(c(1,1,1,1),'lines'))

proportion.learners <- ggplot(finish.data.summary, aes(x=condition,y=p.learn, fill=condition))+
  geom_bar(stat='identity')+
  geom_pointrange(data=empirical.data, aes(y=proportion.mid,ymax=proportion.high, ymin=proportion.low))+
  labs(title="Proportion of subjects who learned\n",x="",y="")+
  scale_fill_hue(guide=F)+
  theme_minimal()+theme(plot.margin=unit(c(1,1,1,1),'lines'))
  

grid.arrange(grobs=list(histograms, mean.se, proportion.learners), heights=c(4,2),layout_matrix=matrix(c(1,1,2,3),nrow=2,byrow=T))
