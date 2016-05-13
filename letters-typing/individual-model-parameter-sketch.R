model.prediction.fake <- function(t, p){
  a.N <- 1100
  a.W <- 1050
  b <- 0.2
  c <- 0.5
  islearner <- 1
  offset.W <- 15
  b.W <- 0.7
  c.W <- 0.8
  
  N <- (a.N * (1 + b*(t^-c - 1)))
  if( t < offset.W || islearner == 2) {
    W <- (a.W * (1 + b*(t^-c - 1)))
  } else {
    W <- (a.W * (1 + b*(t^-c - 1))) * (1 + b.W*((t-offset.W+1)^-c.W - 1))
  }
  
  if(p=="W"){
    return(W)
  } else if(p=="N"){
    return(N)
  }
}

fake.data <- expand.grid(t=1:36,p=c('W','N'))

fake.data$y <- mapply(model.prediction.fake, fake.data$t,fake.data$p)
fake.data$d <- rnorm(nrow(fake.data),fake.data$y,70)

ggplot(fake.data, aes(x=t, y=y, group=p, colour=p))+
  geom_line()+
  geom_point(aes(y=d))+
  theme_minimal()
