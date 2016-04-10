layout(1)
t <- 1:36
y <- function(t,a=1000,b=100,c=15.5) { return(a + b*t^-c - b)}
plot(t,y(t))

t <- -1:36
y <- function(t,b=100,c=0.5) { return(b*t^-c - b)}
plot(t,y(t))


y <- function(t, a = 1100, b = .9, c=.1, b2 = 0.35, c2=30, o=100) {
  if(t < o) {
    return( a * (1 + b * (t^-c - 1)))
  } else {
    return( (a * (1 + b * (t^-c - 1))) * (1 + (b2*((t-o + 1)^-c2 - 1))))
  }
}
t <- 1:72
plot(t,sapply(t, y))


