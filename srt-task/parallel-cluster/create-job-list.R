filename <- 'parallel-cluster/single-subject-job-list-full.txt'
subjects <- 94
reps.per.subject <- 4
command <- 'Rscript run-jags-parallel.R'
lines <- sapply(1:subjects, function(s){
  return(
    sapply(1:reps.per.subject, function(r){
      return(paste(command,s,s*reps.per.subject + r))
    })
  )
})

lines <- as.vector(lines)
fileconn <- file(filename)
writeLines(lines, fileconn)
close(fileconn)