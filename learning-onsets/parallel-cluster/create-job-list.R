filename <- 'parallel-cluster/single-subject-job-list-full.txt'
reps <- 97
command <- 'Rscript run-single-subject-model-parallel.R'
lines <- sapply(1:reps, function(s){
  return(paste(command,s))
})
fileconn <- file(filename)
writeLines(lines, fileconn)
close(fileconn)