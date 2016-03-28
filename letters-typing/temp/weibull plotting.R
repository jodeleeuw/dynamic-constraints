t <- 1:36

y <- function(t, a=80, b=60, c=5, d=16) { return(a - b*(1 - exp(-(t/(d+1))^c)))}

plot(t,y(t), ylim=c(0,100))
