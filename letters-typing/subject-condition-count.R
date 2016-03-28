# load libraries
require(plyr)

# load data
data.all <- read.csv('data/filtered-data.csv')

# count the number of subjects ####
n <- length(unique(data.all$subject))

n.by.condition <- ddply(data.all, .(subject, cond), function(s){ return(T) })
table(n.by.condition$cond)