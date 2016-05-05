source('modeling/DBDA2E-utilities.R')
require(plyr)

# set a random seed so that sampling from the MCMC chains is consistent ####
set.seed(47405)

#### load model and experiment data ####

load('modeling/output/model_run_data.Rdata')
model_run_data$condition <- factor(model_run_data$condition, levels=c("seeded","unseeded"))

load('data/output/experiment-data-summary.Rdata')
data.summarized$seq_condition <- as.numeric(data.summarized$seq_condition)
colnames(data.summarized) <- c('subject','condition','y','N','p')

#### load MCMC chain of gamma fits ####

load('modeling/output/jags-result-gamma-estimation.Rdata')
codaSamples = as.mcmc.list( jags.result )
mcmcMat = as.matrix(codaSamples)

#### generating experimental data from models using gamma fits ####

experimentDataSample <- function(target, foil, gamma){
  sum.denom <- exp(target*gamma) + 5*exp(foil*gamma)
  p <- exp(target*gamma) / sum.denom
  return(p)
}

predicted_data <- model_run_data
predicted_data$target <- as.numeric(predicted_data$target)
predicted_data$foil <- as.numeric(predicted_data$foil)

predicted_data$target <- mapply(function(a,m){
  if(m %in% c('MDLChunker')){ return(-a) }
  else { return(a) }
}, predicted_data$target, predicted_data$model)

predicted_data$foil <- mapply(function(a,m){
  if(m %in% c('MDLChunker')){ return(-a) }
  else { return(a) }
}, predicted_data$foil, predicted_data$model)

predicted_data$p <- mapply(function(a,b,model){
  if(model=='PARSER') { m <- mcmcMat[,"gamma[1]"] }
  if(model=='MDLChunker') { m <- mcmcMat[,"gamma[2]"] }
  gamma <- sample(m,1)
  p <- experimentDataSample(a,b,gamma)
  return(p)
}, predicted_data$target,predicted_data$foil, predicted_data$model)

#### ggplot figure ####

require(ggplot2)
require(gridExtra)

ed_reduced <- ddply(data.summarized, .(condition), function(s)with(s, c(m=mean(p),se=sqrt(var(p)/length(p)))))
ed_reduced$condition <- factor(ed_reduced$condition)
exp_plot <- ggplot(ed_reduced, aes(x=condition,y=m,ymin=m-se,ymax=m+se,fill=condition))+
  geom_bar(width=1, stat="identity",position=position_dodge(width=0.4))+
  geom_errorbar(width=0.25, position=position_dodge(width=0.5),colour=rgb(0,0,0))+
  scale_fill_grey(start=0.2, end=0.6, labels=c("Known words", "Novel words"), guide=FALSE)+
  scale_x_discrete(labels=c("1"="Known words","2"="Novel words"))+
  coord_cartesian(ylim=c(0,1.0))+
  labs(x="\n",y="Proportion of correct responses\n", fill="Condition", title="Experiment data\n")+
  theme_bw()+
  theme_bw(base_size=16,base_family="Helvetica")+
  theme(panel.grid.major.x=element_blank(), panel.grid.minor.x=element_blank(),
        panel.grid.minor.y=element_blank(), panel.grid.major.y=element_line(colour=rgb(0.4,0.4,0.4)),
        legend.position=c(0.75,0.75), panel.border=element_blank(), axis.ticks.x=element_blank(),axis.ticks.y=element_blank())

pd_reduced <- ddply(predicted_data, .(condition, model), function(s)with(s, c(m=mean(p),se=sqrt(var(p)/length(p)))))
pd_reduced$model <- factor(pd_reduced$model)
pd_reduced$condition <- factor(pd_reduced$condition)
model_plot <- ggplot(pd_reduced, aes(x=model,y=m,ymin=m-se,ymax=m+se,fill=condition))+
  geom_bar(width=0.8, stat="identity",position="dodge")+
  geom_errorbar(width=0.25,position=position_dodge(width=0.8),colour=rgb(0,0,0))+
  scale_fill_grey(start=0.2,end=0.6, labels=c("Known words", "Novel words"))+
  #scale_x_discrete(labels=c("1"="PARSER","2"="MDLChunker","3"="TRACX"))+
  coord_cartesian(ylim=c(0,1.0))+
  labs(x="\nModel",y="\n\nProbability of a correct response\n", fill="Condition", title="Model data\n")+
  theme_bw()+
  theme_bw(base_size=16,base_family="Helvetica")+
  theme(panel.grid.major.x=element_blank(), panel.grid.minor.x=element_blank(),
        panel.grid.minor.y=element_blank(), panel.grid.major.y=element_line(colour=rgb(0.4,0.4,0.4)),
        legend.position=c(0.8,0.8), panel.border=element_blank(),
        axis.ticks.y=element_blank(),axis.ticks.x=element_blank())

grid.arrange(arrangeGrob(exp_plot,model_plot, widths=c(1/3,2/3),ncol=2))

#### simple stats on models ####

# PARSER
t.test(p ~ condition, var.equal=F, data=subset(predicted_data, model=='PARSER'))

# MLDChunker
t.test(p ~ condition, var.equal=F, data=subset(predicted_data, model=='MDLChunker'))

# TRACX
#t.test(p ~ condition, var.equal=T, data=subset(predicted_data, model==3))

