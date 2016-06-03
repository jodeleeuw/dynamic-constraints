# dependent.accumulators <- function(n, p.success=0.05, end=100, boost=1){
#   accumulators <- rep(0,n)
#   finish.times <- rep(Inf,n)
#   finished.count <- 0
#   t <- 0
#   while(finished.count < n){
#     t <- t + 1
#     p <- 1 - (1 - p.success)^(1 + boost * finished.count)
#     accumulators <- accumulators + rbinom(n, end, p)
#     finish.times[t < finish.times & accumulators >= end] <- t
#     finished.count <- sum(finish.times < Inf)
#   }
#   return(sort(finish.times))
# }

#### let's try this in Rcpp ####
library(Rcpp)

sourceCpp('model/dependent-accumulator-cpp.cpp')

dependent.accumulators <- dependentAccumulators

#### benchmarking ####
#library(microbenchmark)

#microbenchmark(dependentAccumulators(4,0.02,5,0), dependent.accumulators(4,0.02,5,0))
