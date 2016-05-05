library(coda)

base.path <- 'data/group'

all.files <- list.files(path=base.path, pattern = "\\.Rdata$")

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

for(i in 1:length(all.files)){
  load(paste0(base.path,'/',all.files[i]))
  if(i==1){
    merged.rjags <- jags.result.group   
  } else {
    merged.rjags <- merge.mcmc.lists(merged.rjags, jags.result.group)
  }
}

post.thin <- window(merged.rjags, thin=500)

effectiveSize(post.thin)
gelman.diag(post.thin)

jags.group <- post.thin
save(jags.group, file='data/jags-result-group.Rdata')
