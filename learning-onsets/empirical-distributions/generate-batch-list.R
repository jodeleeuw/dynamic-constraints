filename <- 'empirical-distributions/empirical-dist-job-list.txt'
param.space <- expand.grid(p=seq(from=0.02,to=0.2, by=0.02), end=seq(from=1,to=100,by=10),boost=seq(from=0,to=2,by=0.25))

command <- 'Rscript generate-empirical-distribution-bigred.R'
lines <- sapply(1:nrow(param.space), function(s){
  return(paste(command, param.space[s,1],param.space[s,2],param.space[s,3]))
})
fileconn <- file(filename)
writeLines(lines, fileconn)
close(fileconn)