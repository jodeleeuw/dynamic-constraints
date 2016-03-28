t <- 1:36

y <- function(t, a=80, b=10, c=10, d = 2) { return(a + b*( 1 / (1 + exp((t-d)*c)) ) - b)}

plot(t,y(t))
