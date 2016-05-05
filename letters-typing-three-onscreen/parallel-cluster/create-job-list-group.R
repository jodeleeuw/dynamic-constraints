filename <- 'parallel-cluster/group-model-job-list.txt'
reps <- 63
command <- 'Rscript run-jags-group-model-parallel.R'
lines <- sapply(1:reps, function(s){
  return(paste(command,s))
})
fileconn <- file(filename)
writeLines(lines, fileconn)
close(fileconn)