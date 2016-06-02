#### package requirements ####
require(V8) # to run JS code
require(jsonlite) # to parse JSON output from JavaScript
require(plyr) # data storage manipulation
library(ggplot2)


source('modeling/sequence-generators.R')

#### run it! ####
seq <- four_triple_sequence(36)

ct <- new_context();
ct$source('modeling/models/parser.js')
ct$eval(paste0("PARSER.setup('",seq,"',{",
               "maximum_percept_size: 3,",
               "initial_lexicon_weight: 1,",
               "shaping_weight_threshold: 1,",
               "reinforcement_rate: 0.5,",
               "forgetting_rate: 0.05,",
               "interference_rate: 0.01,",
               "logging: false",
               "});"))
t <- 0
data <- data.frame(t=numeric(), Word=character(), weight=numeric())
while(!as.logical(ct$eval("PARSER.done()"))){
  t <- t + 1
  ct$eval("PARSER.step()")
  w1 <- as.numeric(ct$eval("PARSER.getWordStrength('ABC')"))
  w2 <- as.numeric(ct$eval("PARSER.getWordStrength('DEF')"))
  w3 <- as.numeric(ct$eval("PARSER.getWordStrength('GHI')"))
  w4 <- as.numeric(ct$eval("PARSER.getWordStrength('JKL')"))
  data <- rbind(data, data.frame(t=rep(t,4),Word=c('ABC','DEF','GHI','JKL'),weight=c(w1,w2,w3,w4)))
}


ggplot(data, aes(x=t,y=weight,colour=Word))+
  geom_hline(yintercept=1)+
  geom_line(size=1.5)+
  labs(y="Lexicon weight\n",x="\nModel steps (time)")+
  theme_minimal(base_size=18)
