# libraries
require(coda)
require(plyr)
require(tidyr)
require(ggplot2)
source('lib/DBDA2E-utilities.R')

# load the jags output & model data
load('data/jags-result-individual.Rdata')
load('data/data-for-individual-model.Rdata')

# count subjects
n.subjects <- length(unique(data.for.model$subject))

# subject condition lookup table
subject.conditions <- ddply(data.for.model, .(subject), function(s){return(c(condition=s$cond[[1]]))})


# pick a random set of samples from the posterior
n.samples <- 25
jags.posterior.matrix <- as.matrix(as.mcmc.list(jags.individual),chains=T)
data.posterior.samples <- jags.posterior.matrix[sample(nrow(jags.posterior.matrix), size=n.samples, replace=FALSE),]

# plot proportion of time model ####
subject.p.learner <- data.frame(subject=1:n.subjects)
subject.p.learner$p <- sapply(subject.p.learner$subject, function(s){
  vector <- jags.posterior.matrix[,paste0('is.learner[',s,']')]
  return( table(vector)[[1]] / length(vector) )
})
subject.p.learner$condition <- factor(sapply(subject.p.learner$subject, function(s){ return(subject.conditions[subject.conditions$subject==s,]$condition)}))
subject.p.learner <- subject.p.learner[order(subject.p.learner$p, subject.p.learner$condition),]
subject.p.learner$sortorder <- 1:nrow(subject.p.learner)
ggplot(subject.p.learner, aes(x=sortorder, y=p, fill=condition))+
  geom_bar(stat='identity')+
  labs(x="\nSubject", y="Proportion of samples classified as learner\n")+
  scale_x_continuous(breaks=seq(from=0,to=275,by=25))+
  scale_fill_hue(labels=c('Known words', 'Novel words', 'Scrambled'), name='Context')+
  theme_minimal(base_size=14)

save(subject.p.learner, file='data/subject.p.learn.Rdata')

# n subjects above 50%, 75%
sum(subject.p.learner$p>=0.5)/nrow(subject.p.learner)
sum(subject.p.learner$p>=0.75)/nrow(subject.p.learner)


# get HDIs for subject-level params of interest ####
subject.hdi <- expand.grid(subject=1:n.subjects, loc=c('low','high','median'), parameter=c('b.adapt','c.adapt','b.W','c.W','offset.W'))
subject.hdi$value <- mapply(function(s,l,p){
  vector <- jags.posterior.matrix[,paste0(p,'[',s,']')]
  # only look at learning curve params when subject is a learner
  if(p %in% c('offset.W', 'b.W','c.W')) {
    islearner <- jags.posterior.matrix[,paste0('is.learner[',s,']')]
    vector <- vector[islearner==1] 
  }
  limits <- HDIofMCMC(vector)
  if(l=='low') { return(limits[1]) }
  if(l=='high') { return(limits[2])}
  if(l=='median') { return(median(vector)) }
},subject.hdi$subject, subject.hdi$loc, subject.hdi$parameter)
subject.hdi <- subject.hdi %>% spread('loc','value')
subject.hdi$condition <- factor(sapply(subject.hdi$subject, function(s){ return(subject.conditions[subject.conditions$subject==s,]$condition)}))
subject.hdi$p.learner <- sapply(subject.hdi$subject, function(s){ return(subject.p.learner[subject.p.learner$subject==s,]$p)})
# looking at subject level params ####
hdi.plotting.data <- subset(subject.hdi, p.learner >= 0.75 & parameter%in%c('offset.W','b.W','c.W'))
hdi.plotting.data$parameter <- factor(as.character(hdi.plotting.data$parameter))
hdi.plotting.data$parameter <- revalue(hdi.plotting.data$parameter, c('b.W'='\u03B2[learn] ~ "(amount of learning)"','c.W'='\u03B3[learn] ~ "(speed of learning)"','offset.W'='\u03C9 ~ "(onset of learning)"'))
hdi.plotting.data$order <- rank(hdi.plotting.data$condition, ties.method = 'first')
ggplot(hdi.plotting.data, aes(x=order,ymin=low,ymax=high, y=median, colour=condition))+
  geom_pointrange()+
  facet_wrap(~parameter, scales="free_y",labeller = label_parsed)+
  labs(y="Parameter value\n",x="")+
  scale_x_discrete(expand=c(.05,.05))+
  scale_y_continuous(limits=c(0,NA))+
  scale_color_hue(labels=c('Known words','Novel words','Scrambled'),name="Context")+
  theme_minimal(base_size = 14) +
  theme(strip.text=element_text(family='Times New Roman', size=14))

# export onset data
levels(hdi.plotting.data$parameter)
onset.data <- subset(hdi.plotting.data, parameter==levels(hdi.plotting.data$parameter)[3] ,c('median','condition'))

# plotting subject model data ####

model.prediction <- function(row, subject, t, p){
  a.N <- row[paste0('a.adapt[',subject,',1]')]
  a.W <- row[paste0('a.adapt[',subject,',2]')]
  b <- row[paste0('b.adapt[',subject,']')]
  c <- row[paste0('c.adapt[',subject,']')]
  islearner <- row[paste0('is.learner[',subject,']')]
  offset.W <- row[paste0('offset.W[',subject,']')]
  b.W <- row[paste0('b.W[',subject,']')]
  c.W <- row[paste0('c.W[',subject,']')]
  
  N <- (a.N * (1 + b*(t^-c - 1)))
  if( t < offset.W || islearner == 2) {
    W <- (a.W * (1 + b*(t^-c - 1)))
  } else {
    W <- (a.W * (1 + b*(t^-c - 1))) * (1 + b.W*((t-offset.W+1)^-c.W - 1))
  }
  
  if(p=="rt.W"){
    return(W)
  } else if(p=="rt.N"){
    return(N)
  }
}

# list of subject conditions
subject.conditions <- data.frame(subject=1:n.subjects)
subject.conditions$cond <- sapply(subject.conditions$subject, function(s){
  c <- subset(data.for.model, subject==s)$cond[1]
  return(c)
})

# empty data frame to fill with posterior predictions
data.posterior.overlay <- data.frame(i=numeric(),t=numeric(),y=numeric(),subject=numeric())

model.prediction.base <- expand.grid(subject=1:n.subjects, t=1:72, letter=c('rt.N','rt.W'))
# iterate over samples and generate predictions
for(i in 1:nrow(data.posterior.samples)){
  r <- data.posterior.samples[i,]
  new.df <- model.prediction.base
  new.df$y <- mapply(model.prediction, subject = new.df$subject, t=new.df$t, p=new.df$letter, MoreArgs = list(row=r))
  new.df$i <- i
  data.posterior.overlay <- rbind(data.posterior.overlay,new.df)
}
data.posterior.overlay$cond <- sapply(data.posterior.overlay$subject, function(s){
  c <- subset(subject.conditions, subject==s)$cond
  return(c)
})
data.posterior.overlay$letter <- factor(as.character(data.posterior.overlay$letter), levels=c('rt.W','rt.N'))

data.for.plotting <- data.for.model %>% gather(letter,rt,4:5)
data.for.plotting$letter <- factor(as.character(data.for.plotting$letter), levels=c('rt.W','rt.N'))

# n.per.panel <- 20
# total.panels <- ceiling(n.subjects/20)
# for(i in 1:total.panels){
#   subject.subset <- ((i-1)*n.per.panel + 1):(n.per.panel*i)
#   p <- ggplot(subset(data.for.plotting, subject %in% subject.subset), aes(x=t,y=rt,colour=interaction(letter,cond)))+
#     geom_point(alpha=1)+
#     geom_line(data=subset(data.posterior.overlay, subject %in% subject.subset), aes(x=t,y=y,colour=interaction(letter,cond),group=interaction(i,letter)), alpha=0.2)+
#     scale_colour_manual(name="Context", labels=c("W - Three known words", "N - Three known words", "W - Three unknown words", "N - Three unknown words",  "W - Scrambled", "N - Scrambled"), values=c('#a50f15','#fcae91','#006d2c','#bae4b3','#08519c','#bdd7e7'))+
#     labs(x="\nNumber of times the letter has appeared in the sequence", y="RT (ms)\n", title="Response times to N and W")+
#     facet_wrap(~subject)+
#     theme_minimal()
#   print(p)
# }

# plot subset of subjects with different learning outcomes
sample.subjects <- c(55,126,184, 110,251,175, 201,100,28)
sample.plotting.data <- subset(data.for.plotting, subject %in% sample.subjects)
sample.plotting.data$subject <- factor(sample.plotting.data$subject, levels=sample.subjects)
sample.overlay.data <- subset(data.posterior.overlay, subject %in% sample.subjects)
sample.overlay.data$subject<- factor(sample.overlay.data$subject, levels=sample.subjects)
subject.labels <- sapply(as.character(sample.subjects), function(x){
  return(paste0("Subject ",x,", p(learn) = ",round(subset(subject.p.learner,subject==x)$p,digits=3)))
})
ggplot(sample.plotting.data, aes(x=t,y=rt,colour=interaction(letter,cond)))+
  geom_point(alpha=1)+
  geom_line(data=sample.overlay.data, aes(x=t,y=y,colour=interaction(letter,cond),group=interaction(i,letter)), alpha=0.2)+
  scale_colour_manual(name="Context", labels=c("W - Known words", "N - Known words", "W - Novel words", "N - Novel words",  "W - Scrambled", "N - Scrambled"), values=c('#a50f15','#fcae91','#006d2c','#bae4b3','#08519c','#bdd7e7'))+
  labs(x="\nNumber of times the letter has appeared in the sequence", y="RT (ms)\n", title="Response times to N and W")+
  facet_wrap(~subject, labeller = labeller(subject=subject.labels))+
  theme_minimal()

# plot the subject who had no offset for learning
ggplot(subset(data.for.plotting, subject %in% c(51)), aes(x=t,y=rt,colour=interaction(letter,cond)))+
  geom_point(alpha=1)+
  geom_line(data=subset(data.posterior.overlay, subject %in% c(51)), aes(x=t,y=y,colour=interaction(letter,cond),group=interaction(i,letter)), alpha=0.2)+
  scale_colour_manual(name="Context", labels=c("W - Known words", "N - Known words", "W - Novel words", "N - Novel words",  "W - Scrambled", "N - Scrambled"), values=c('#a50f15','#fcae91','#006d2c','#bae4b3','#08519c','#bdd7e7'))+
  labs(x="\nNumber of times the letter has appeared in the sequence", y="RT (ms)\n", title="Response times to N and W")+
  theme_minimal()

# plot HDIs for conditions ####
layout(matrix(1:6, ncol=2))
plotPost(jags.posterior.matrix[,'learner.cond[1]'],xlab="Known words",xlim=c(0,1),main=expression(theta[c]), cex.main=2.5)
plotPost(jags.posterior.matrix[,'learner.cond[2]'],xlab="Novel words",xlim=c(0,1))
plotPost(jags.posterior.matrix[,'learner.cond[3]'],xlab="Scrambled",xlim=c(0,1))
plotPost(jags.posterior.matrix[,'offset.mode[1]'],xlab="Known words",xlim=c(0,50),main=expression(phi[c]), cex.main=2.5)
plotPost(jags.posterior.matrix[,'offset.mode[2]'],xlab="Novel words",xlim=c(0,50))
plotPost(jags.posterior.matrix[,'offset.mode[3]'],xlab="Scrambled",xlim=c(0,50))

# plot HDIs for group parameters ####
#layout(1:2)
layout(matrix(1:6, ncol=2))
plotPost(jags.posterior.matrix[,'b.W.group.mode[1]'])
plotPost(jags.posterior.matrix[,'b.W.group.mode[2]'])
plotPost(jags.posterior.matrix[,'b.W.group.mode[3]'])
plotPost(jags.posterior.matrix[,'c.W.group[1]'])
plotPost(jags.posterior.matrix[,'c.W.group[2]'])
plotPost(jags.posterior.matrix[,'c.W.group[3]'])
