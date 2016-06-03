library(coda)

base.path <- 'data/individual'

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
  load(paste0(base.path,'/',all.files[i]), verbose=T)
  thinned <- window(jags.result.individual, thin=40)
  if(i==1){
    merged.rjags <- thinned  
  } else {
    merged.rjags <- merge.mcmc.lists(merged.rjags, thinned)
  }
}

es <- effectiveSize(merged.rjags)
#gelman.diag(merged.rjags)

jags.individual <- merged.rjags
save(jags.individual, file='data/jags-result-individual.Rdata')
