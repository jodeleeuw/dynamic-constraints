filename <- 'parallel-cluster/individual-model-job-list-full.txt'
reps <- 127
command <- 'Rscript run-jags-individual-model-parallel.R'
lines <- sapply(1:reps, function(s){
  return(paste(command,s))
})
fileconn <- file(filename)
writeLines(lines, fileconn)
close(fileconn)