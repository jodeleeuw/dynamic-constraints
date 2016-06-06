library(plyr)
library(ggplot2)
library(gridExtra)
library(grid)

# load model ####
source('model/dependent-accumulator-model.R')

# set shared params
# good candidate -> 0.01, 3, 100
p <- 0.02
end <- 3
boost <- 100

reps <- 1000

# predict learning time for W (of NIW triple) in four triple condition
# with boost
f.times.four.boost <- replicate(reps, {dependent.accumulators.no.sort(4, p, end, boost)[[1]]})

# no boost
f.times.four.no.boost <- replicate(reps, {dependent.accumulators.no.sort(4, p,end,0)[[1]]})

# predict learning time in the one triple condition
f.times.one <- replicate(reps, {dependent.accumulators.no.sort(1,p,end,0)[[1]]})

# make data frame
finish.data <- data.frame(condition=c(rep("Four triples - dependent", reps), rep("Four triples - independent", reps), rep("One triple", reps)),
                          finish.time=c(f.times.four.boost, f.times.four.no.boost, f.times.one))

finish.data.summary <- ddply(finish.data, .(condition), function(s){
  in.time <- s$finish.time[s$finish.time <= 72]
  m <- mean(in.time)
  se <- sd(in.time) / sqrt(length(in.time))
  p.learn <- length(in.time) / nrow(s)
  return(c(m=m,se=se,p.learn=p.learn))
})

# empirical data ####
empirical.data <- data.frame(condition=c('Four triples - dependent', 'Four triples - independent', 'One triple'),
                             onset.mid=c(29.3,29.3,40.1),onset.low=c(26.8,26.8,36.2),onset.high=c(31.6,31.6,44.7),
                             proportion.mid=c(0.304,0.304,0.179),proportion.low=c(0.207,0.207,0.0976),proportion.high=c(0.431,0.431,0.285))

# make plots ####
max.val <- max(finish.data$finish.time)+1

histograms <- ggplot(finish.data, aes(x=finish.time, fill=condition))+
  geom_histogram(alpha=0.6, position = 'identity', bins=60)+
  geom_vline(xintercept = 72)+
  theme_minimal()+
  labs(x="Accumulator finish time", y="Frequency",fill="Condition",title="Learning onset for target triple")+
  scale_x_continuous(limits=c(0,max.val))+
  scale_fill_manual(values=c(hcl(135,100,65), hcl(195,100,65), hcl(255,100,65)))+
  theme(axis.text.y=element_blank())

mean.se <- ggplot(finish.data.summary, aes(x=condition, colour=condition, y=m, ymax=m+1.96*se, ymin=m-1.96*se))+
  geom_point(size=2)+
  #geom_pointrange(data=empirical.data, aes(y=onset.mid,ymax=onset.high,ymin=onset.low))+
  scale_y_continuous(limits=c(0,72))+
  labs(y="Learning onset", x="",title="Mean onset of learning for participants who learned")+
  coord_flip()+
  scale_color_manual(values=c(hcl(135,100,65), hcl(195,100,65), hcl(255,100,65)),guide=F)+
  theme_minimal()+
  theme(axis.text.y=element_blank(), plot.margin=unit(c(1,1,1,1),'lines'))

proportion.learners <- ggplot(finish.data.summary, aes(x=condition,y=p.learn, fill=condition))+
  geom_bar(stat='identity')+
  #geom_pointrange(data=empirical.data, aes(y=proportion.mid, ymax=proportion.high, ymin=proportion.low))+
  labs(title="Proportion of participants who learned\n",x="",y="")+
  scale_fill_manual(values=c(hcl(135,100,65), hcl(195,100,65), hcl(255,100,65)), guide=F)+
  theme_minimal()+theme(plot.margin=unit(c(1,1,1,1),'lines'))
  
grid.arrange(grobs=list(histograms, mean.se, proportion.learners), heights=c(4,2),layout_matrix=matrix(c(1,1,2,3),nrow=2,byrow=T))
