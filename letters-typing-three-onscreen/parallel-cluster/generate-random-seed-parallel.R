library(microbenchmark, lib.loc = '~/R-packages')

get.seed <- function(){
  random.seed <- round(sum(microbenchmark(runif(10000))$time))
  return(random.seed)
}