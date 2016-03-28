# load libraries
require(ggplot2)
require(plyr)

# load the data
data.all <- read.csv('data/filtered-data.csv')

# get only the data from test trials
data.test <- subset(data.all, practice == 0)

# add a column that indicates how many times a letter has appeared in the experiment
n_subjects <- length(unique(data.test$subject))
data.test$appearanceCount <- rep(as.vector(sapply(1:36, function(x){return(rep(x,12))})), n_subjects)

# plot by subject
data.plot <- subset(data.test, correct==1 & triple_position%in%c(2,3) & triple_type == 'critical')
ggplot(data.plot, aes(x=appearanceCount, y=rt, colour=cond))+
  geom_line()+
  facet_wrap(~subject)

# plot differences by subject
data.differences <- ddply(subset(data.test, correct==1 & triple_type == 'critical'), .(subject, cond, appearanceCount), function(s){
  p.2.3 <- mean(subset(s, triple_position%in%c(2,3))$rt)
  p.1 <- subset(s, triple_position==1)$rt
  if(length(p.1)==0 || length(p.2.3)==0){
    return(c(difference=NA))
  }
  return(c(difference=p.2.3 - p.1))
})
ggplot(data.differences, aes(x=appearanceCount, y=difference, colour=cond))+
  geom_line()+
  facet_wrap(~subject)

