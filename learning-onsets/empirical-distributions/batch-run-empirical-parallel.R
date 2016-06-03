library(foreach)
library(doMC)

source('empirical-distributions/generate-empirical-distribution.R')

p <- seq(from=0.01, to=0.2, by=0.01)
end <- seq(from=1, to=39, by=2)
boost <- seq(from=0,to=2,by=0.125)

param.space <- expand.grid(p=p, end=end,boost=boost)
#param.space <- expand.grid(p=c(0.05,0.1),end=c(2,10),boost=c(0,0.5))

# create parallel cluster
registerDoMC(cores=6)

# describe function
run.once <- function(r){
  v <- param.space[r,]
  a <- proc.time()
  run.and.save(v$p, v$end, v$boost, 4, 10000000, 72, 'empirical-distributions/model-recovery-distributions/')
  b <- proc.time()
  sink('parallel-log.txt', append = T)
  print(paste('Completed',r,'of',nrow(param.space),'Time for last sim:',(b-a)['elapsed']))
}

foreach(r=1:nrow(param.space)) %dopar% run.once(r)
