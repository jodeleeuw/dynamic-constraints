library(plyr)
library(ggplot2)
library(gridExtra)
library(grid)
library(DEoptim)

# load model ####
source('model/dependent-accumulator-model.R')

reps <- 1000

empirical.data <- c(18.1, 29.3, 40.1, .717, .304, .179)
empirical.range <- c(72, 72, 72, 1, 1, 1)

model <- function(params){

  #if(any(params < 0) || any(params > 1)) { return(NA) }
  
  m <- sample(c(params[1], params[1]*params[2]), reps, replace=T, prob=c(1-params[3], params[3]))
  k <- params[4]
  a <- m*(k-2)+1
  b <- (1-m)*(k-2)+1
  p <- rbeta(reps, a,b)
  #hist(p, breaks=100)
  #p <- params[1]
  end <- params[5]
  boost <- params[6]
  pre.k <- params[7]
  
  # predict learning time for W (of NIW triple) in four triple condition
  # with boost
  f.times.four.known <- sapply(1:reps, function(x){dependent.accumulators.with.boundary(4, p[x], end, boost, c(0,rep(floor(end*pre.k),3)), 100)[[1]]})
  
  # no boost
  f.times.four.unknown <- sapply(1:reps, function(x){dependent.accumulators.with.boundary(4, p[x], end, boost, c(0, 0, 0, 0), 100)[[1]]})
  
  # predict learning time in the one triple condition
  f.times.one <- sapply(1:reps, function(x){dependent.accumulators.with.boundary(1,p[x],end,0, c(0), 100)[[1]]})
  
  
  model.data = c(
    mean(f.times.four.known[f.times.four.known %in% 1:72 ]),
    mean(f.times.four.unknown[f.times.four.unknown %in% 1:72]),
    mean(f.times.one[f.times.one  %in% 1:72]),
    sum(f.times.four.known %in% 1:72) / length(f.times.four.known),
    sum(f.times.four.unknown  %in% 1:72) / length(f.times.four.unknown),
    sum(f.times.one %in% 1:72) / length(f.times.one)
  )
  
  n.rmse = sqrt(((model.data - empirical.data) / empirical.range)^2)
  out <- sum(n.rmse)
  if(is.nan(out)){
    out <- Inf
  }
  return(out)
  
}

params = c(0.01, 20, 0.8, 50, 1, 0, 0)
model(params)

mappingFun <- function(x){
  x[2] <- min(1/x[1], x[2])
  x[5] <- round(x[5])
  actualStart <- floor(x[5]*x[7])
  x[7] <- actualStart/x[5]
  return(x)
}

# slow, fast mult, proportion fast, concentration, end, boost, pre.k
result <- DEoptim(model, lower=c(0.00001, 1, 0, 0, 1, 0, 0), upper=c(1,1000,1,500,1000,100,1), fnMap=mappingFun, control=list(NP=100, itermax=300))

# empirical data ####


# make plots ####
# max.val <- max(finish.data$finish.time)+1
# 
# histograms <- ggplot(finish.data, aes(x=finish.time, fill=condition))+
#   geom_histogram(alpha=0.6, position = 'identity', bins=101)+
#   geom_vline(xintercept = 72)+
#   theme_minimal()+
#   labs(x="Accumulator finish time", y="Frequency",fill="Condition",title="Learning onset for target triple")+
#   scale_x_continuous(limits=c(0,100))+
#   theme(axis.text.y=element_blank())
# 
# mean.se <- ggplot(finish.data.summary, aes(x=condition, colour=condition, y=m, ymax=m+1.96*se, ymin=m-1.96*se))+
#   geom_point(shape=108,size=10)+
#   geom_pointrange(data=empirical.data, colour='black', aes(y=onset.mid, ymax=onset.high, ymin=onset.low))+
#   scale_y_continuous(limits=c(0,72))+
#   labs(y="Learning onset", x="",title="Mean onset of learning for subjects who learned")+
#   coord_flip()+
#   scale_color_hue(guide=F)+
#   theme_minimal()+
#   theme(axis.text.y=element_blank(), plot.margin=unit(c(1,1,1,1),'lines'))
# 
# proportion.learners <- ggplot(finish.data.summary, aes(x=condition,y=p.learn, fill=condition))+
#   geom_bar(stat='identity')+
#   geom_pointrange(data=empirical.data, aes(y=proportion.mid,ymax=proportion.high, ymin=proportion.low))+
#   labs(title="Proportion of subjects who learned\n",x="",y="")+
#   scale_fill_hue(guide=F)+
#   theme_minimal()+theme(plot.margin=unit(c(1,1,1,1),'lines'))
#   
# 
# grid.arrange(grobs=list(histograms, mean.se, proportion.learners), heights=c(4,2),layout_matrix=matrix(c(1,1,2,3),nrow=2,byrow=T))
