# load required libraries
require(plyr)
require(ggplot2)
require(tidyr)

# load the filtered data
data.all <- read.csv('data/filtered-data.csv')

# get only the data from test trials
data.test <- subset(data.all, practice == 0)

# add a column that indicates how many times a letter has appeared in the experiment
n_subjects <- length(unique(data.test$subject))
data.test$appearanceCount <- rep(as.vector(sapply(1:36, function(x){return(rep(x,12))})), n_subjects)

# plot of time (appearance index) X condition for critical trials ####
data.plot <- subset(data.test,correct==1 & triple_type == 'critical')
data.plot$cond <- factor(data.plot$cond, levels= c('known', 'unknown', 'one'))
se <- function(x) sd(x)/sqrt(length(x))
ggplot(data.plot, aes(x=appearanceCount, y=rt, colour=cond))+
  stat_summary(fun.y = mean, fun.ymax = function(x){return(mean(x)+se(x))}, fun.ymin = function(x){return(mean(x)-se(x))})+
  facet_grid(.~triple_position, labeller = labeller(triple_position=c("1"="N", "2"="I", "3"="W")))+
  labs(title="Response times to N / I / W triple", x="\nNumber of times the letter has appeared in the sequence",y="RT (ms)\n")+
  scale_colour_hue(name="Context", labels=c("Three Known Words","Three Unknown Words", "Scrambled"))+
  theme_minimal(base_size=18)

