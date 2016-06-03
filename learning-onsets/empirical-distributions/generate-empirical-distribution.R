source('model/dependent-accumulator-model.R')
library(jsonlite)

generate.empirical.distribution <- function(p, end, boost, n, reps, maxFinishTime){
  return(rle(empiricalLikelihood(n,p,end,boost,reps,maxFinishTime)))
}

save.empirical.distribution <- function(p, end, boost, n, reps, result, maxFinishTime, directory){
  to.write <- list(
    parameters = list(
      p=p,
      end=end,
      boost=boost,
      n=n,
      max=maxFinishTime,
      reps=reps
    ),
    result = list(
      values = result$values,
      lengths = result$lengths
    )
  )
  json <- toJSON(to.write)
  write(json, file=paste0(directory, paste(p,end,boost,n,sep='-'),'.json'))
}

run.and.save <- function(p, end, boost, n, reps, maxFinishTime, directory){
  r <- generate.empirical.distribution(p, end, boost, n, reps, maxFinishTime)
  save.empirical.distribution(p,end,boost,n,reps,r, maxFinishTime,directory)
}

#run.and.save(0.05,50,1,4,100000,72,'empirical-distributions/sim-results/')
