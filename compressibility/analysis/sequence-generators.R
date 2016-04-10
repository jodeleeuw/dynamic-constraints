#### sequence generators ####

create_base_sequence <- function(reps){
  items <- 1:4
  s <- sample(items,4)
  for(i in 2:reps){
    p <- sample(items,4)
    while(p[1] == s[length(s)]){
      p <- sample(items,4)
    }
    s <- c(s,p)
  }
  return(s)
}

four_triple_sequence <- function(reps){
  triples <- c('ABC','DEF','GHI','JKL')
  s <- create_base_sequence(reps)
  s2 <- sapply(s, function(i){ return(triples[i])})
  final <- paste0(s2, collapse="")
  return(final)
}

one_triple_sequence <- function(reps){
  triples <- c('ABC','DEF','GHI','JKL')
  s <- create_base_sequence(reps)
  s2 <- sapply(s, function(i){ 
    if(i==1){
      return(triples[i])
    } else {
      return(paste0(sample(strsplit(triples[i],split="")[[1]],3),collapse=""))
    }
  })
  final <- paste0(s2, collapse="")
  return(final)
}