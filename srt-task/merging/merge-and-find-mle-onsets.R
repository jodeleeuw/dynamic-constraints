library(coda)

base.path <- 'data/mcmc'

all.files <- list.files(path=base.path, pattern = "\\.Rdata$")

n.subjects <- length(all.files) / 4

merge.mcmc.lists <- function(mcmclist.1, mcmclist.2){
  total.size <- length(mcmclist.1) + length(mcmclist.2)
  final.list <- vector("list", total.size)
  i <- 1
  for(a in 1:length(mcmclist.1)){
    final.list[[i]] <- mcmclist.1[[a]]
    i <- i + 1
  }
  for(b in 1:length(mcmclist.2)){
    final.list[[i]] <- mcmclist.2[[b]]
    i <- i + 1
  }
  new.mcmc.list <- mcmc.list(final.list)
  return(new.mcmc.list)
}

subject.data <- expand.grid(subject=1:n.subjects, param=c('is.learner',paste0('c[',1:12,']')), value=c(NA))

for(i in 1:n.subjects){
  files <- list.files(path=base.path, pattern = paste0("jags-result-single-subject-",i,"-"))
  for(f in 1:length(files)){
    load(paste0(base.path,'/',files[f]), verbose=T)
    if(f==1){
      merged.jags <- jags.result.single.subject
    } else {
      merged.jags <- merge.mcmc.lists(merged.jags, jags.result.single.subject)
    }
  }
  
  # convert to matrix
  posterior <- as.matrix(merged.jags)
  
  # first get p(learner)
  subject.data[subject.data$subject==i & subject.data$param=='is.learner'] <- sum(posterior[,'is.learner']) / length(posterior[,'is.learner'])
}