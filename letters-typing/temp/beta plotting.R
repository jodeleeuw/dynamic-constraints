m <- 0.25
k <- 5

a <- m*(k-2)+1
b <- (1-m)*(k-2)+1

s <- seq(from=0,to=1,by=0.05)
plot(s, dbeta(s,a,b))