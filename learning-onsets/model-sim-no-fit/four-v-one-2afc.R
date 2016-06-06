library(plyr)
library(ggplot2)
library(gridExtra)
library(grid)

# load model ####
source('model/dependent-accumulator-model.R')

# set shared params
# good candidate -> 0.01, 3, 100
reps <- 1000
p <- rbeta(reps, 1, 100)
end <- rpois(reps, 0) + 1
boost <- 100



# predict learning time for W (of NIW triple) in four triple condition
# with boost
finished.boost <- sapply(1:reps, function(x){sum(dependent.accumulators.no.sort(4, p[x], end[x], boost)<=25)})

# no boost
finished.no.boost <- sapply(1:reps, function(x){sum(dependent.accumulators.no.sort(4, p[x], end[x], 0)<=25)})

# predict learning time in the one triple condition
finished.one <- sapply(1:reps, function(x){sum(dependent.accumulators.no.sort(1,p[x],end[x],0)<=25)})

# make data frame
finish.data <- data.frame(condition=c(rep("Four triples - dependent", reps), rep("Four triples - independent", reps), rep("One triple", reps)),
                          finished.count=c(finished.boost, finished.no.boost, finished.one))

finish.data$proportion.correct <- mapply(function(c,f){
  if(c=='One triple'){
    return(.5 + f*.5)
  } else {
    return(.5 + f*.125)
  }
},finish.data$condition,finish.data$finished.count)

finish.data.summary <- ddply(finish.data, .(condition), function(s){
  return(c(m=mean(s$proportion.correct), se=(sd(s$proportion.correct)/sqrt(length(s$proportion.correct)))))
})

# make plots ####

ggplot(finish.data.summary, aes(x=condition, y=m, ymax=m+se,ymin=m-se))+
  geom_pointrange()+
  theme_minimal()

# max.val <- max(finish.data$finish.time)+1
# 
# histograms <- ggplot(finish.data, aes(x=finish.time, fill=condition))+
#   geom_histogram(alpha=0.6, position = 'identity', bins=30)+
#   geom_vline(xintercept = 72)+
#   theme_minimal()+
#   labs(x="Accumulator finish time", y="Frequency",fill="Condition",title="Learning onset for target triple")+
#   scale_x_continuous(limits=c(0,200))+
#   theme(axis.text.y=element_blank())
# 
# mean.se <- ggplot(finish.data.summary, aes(x=condition, colour=condition, y=m, ymax=m+1.96*se, ymin=m-1.96*se))+
#   geom_pointrange(size=1)+
#   scale_y_continuous(limits=c(0,72))+
#   labs(y="Learning onset", x="",title="Mean onset of learning for subjects who learned")+
#   coord_flip()+
#   scale_color_hue(guide=F)+
#   theme_minimal()+
#   theme(axis.text.y=element_blank(), plot.margin=unit(c(1,1,1,1),'lines'))
# 
# proportion.learners <- ggplot(finish.data.summary, aes(x=condition,y=p.learn, fill=condition))+
#   geom_bar(stat='identity')+
#   labs(title="Proportion of subjects who learned\n",x="",y="")+
#   scale_fill_hue(guide=F)+
#   theme_minimal()+theme(plot.margin=unit(c(1,1,1,1),'lines'))
#   
# 
# grid.arrange(grobs=list(histograms, mean.se, proportion.learners), heights=c(4,2),layout_matrix=matrix(c(1,1,2,3),nrow=2,byrow=T))
