source('empirical-distributions/generate-empirical-distribution.R')

param.space <- expand.grid(p=seq(from=0.02,to=0.2, by=0.02), end=seq(from=1,to=100,by=10),boost=seq(from=0,to=2,by=0.25))
#param.space <- expand.grid(p=c(0.05,0.1),end=c(2,10),boost=c(0,0.5))

for(r in 1:nrow(param.space)){
  v <- param.space[r,]
  a <- Sys.time()
  run.and.save(v$p, v$end, v$boost, 4, 10000000, 72, 'empirical-distributions/sim-results/')
  b <- Sys.time()
  print(paste('Completed',r,'of',nrow(param.space),'Time for last sim:',(b-a)))
}
