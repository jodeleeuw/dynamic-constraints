soft.norm <- function(x, gamma){
  sum.e.x <- sum(exp(x*gamma))
  y <- exp(x*gamma) / sum.e.x
  return(y)
}
soft.norm(c(1,1,1,1,1,3), 0.1)
