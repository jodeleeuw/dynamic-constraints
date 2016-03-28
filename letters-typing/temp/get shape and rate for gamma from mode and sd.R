g.mode <- 0.1
g.sd <- 1

(rate <- (g.mode + sqrt(g.mode^2 + 4*g.sd^2)) / (2*g.sd^2))
(shape <- 1 + g.mode*rate)

x <- seq(from=0,to=g.mode+g.sd*10,by=g.sd/100)
plot(x, dgamma(x,shape,rate))
