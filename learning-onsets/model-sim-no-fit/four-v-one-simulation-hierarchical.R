library(plyr)
library(ggplot2)
library(gridExtra)
library(grid)

# load model ####
source('model/dependent-accumulator-model.R')

# set shared params
reps <- 10000
p <- rbeta(reps, 1, 150)
end <- rpois(reps, 3) + 1
boost <- 100


# predict learning time for W (of NIW triple) in four triple condition
# with boost
f.times.four.boost <- sapply(1:reps, function(x){dependent.accumulators.no.sort(4, p[x], end[x], boost)[[1]]})

# no boost
f.times.four.no.boost <- sapply(1:reps, function(x){dependent.accumulators.no.sort(4, p[x], end[x], 0)[[1]]})

# predict learning time in the one triple condition
f.times.one <- sapply(1:reps, function(x){dependent.accumulators.no.sort(1,p[x],end[x],0)[[1]]})

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

# make plots ####
max.val <- max(finish.data$finish.time)+1

histograms <- ggplot(finish.data, aes(x=finish.time, fill=condition))+
  geom_histogram(alpha=0.6, position = 'identity', bins=30)+
  geom_vline(xintercept = 72)+
  theme_minimal()+
  labs(x="Accumulator finish time", y="Frequency",fill="Condition",title="Learning onset for target triple")+
  scale_x_continuous(limits=c(0,200))+
  theme(axis.text.y=element_blank())

mean.se <- ggplot(finish.data.summary, aes(x=condition, colour=condition, y=m, ymax=m+1.96*se, ymin=m-1.96*se))+
  geom_pointrange(size=1)+
  scale_y_continuous(limits=c(0,72))+
  labs(y="Learning onset", x="",title="Mean onset of learning for subjects who learned")+
  coord_flip()+
  scale_color_hue(guide=F)+
  theme_minimal()+
  theme(axis.text.y=element_blank(), plot.margin=unit(c(1,1,1,1),'lines'))

proportion.learners <- ggplot(finish.data.summary, aes(x=condition,y=p.learn, fill=condition))+
  geom_bar(stat='identity')+
  labs(title="Proportion of subjects who learned\n",x="",y="")+
  scale_fill_hue(guide=F)+
  theme_minimal()+theme(plot.margin=unit(c(1,1,1,1),'lines'))
  

grid.arrange(grobs=list(histograms, mean.se, proportion.learners), heights=c(4,2),layout_matrix=matrix(c(1,1,2,3),nrow=2,byrow=T))
