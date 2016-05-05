#
# Model evaluation for de Leeuw & Goldstone 2015
#

#### package requirements ####
require(V8) # to run JS code
require(jsonlite) # to parse JSON output from JavaScript
require(plyr) # data storage manipulation

#### load script that can generate sequences ####
source('modeling/sequence-generators.R')

#### set parameters for model testing ####

reps_per_condition <- 1000
reps_per_item_in_seq <- 25 # behavioral experiment was 25

# PARSER parameters

PARSER_maximum_percept_size <- 3
PARSER_initial_lexicon_weight <- 1
PARSER_shaping_weight_threshold <- 1
PARSER_reinforcement_rate <- 0.5
PARSER_forgetting_rate <- 0.05
PARSER_interference_rate <- 0.005
PARSER_logging <- "false"

# gamma for softmax
gamma_smax <- .226

#### functions to run each model once ####

run_PARSER_params <- function(model, seq, condition) {
  
  if(condition=='seeded'){
    seed_str <- ",[{word:['D','E','F'], weight: 100.0},{word:['G','H','I'], weight: 100.0},{word:['J','K','L'], weight: 100.0}]"
  } else {
    seed_str <- ""
  }
  
  ct <- new_context();
  ct$source(model)
  ct$eval(paste0("PARSER.setup('",seq,"',{",
                 "maximum_percept_size:",PARSER_maximum_percept_size,",",
                 "initial_lexicon_weight:",PARSER_initial_lexicon_weight,",",
                 "shaping_weight_threshold:",PARSER_shaping_weight_threshold,",",
                 "reinforcement_rate:",PARSER_reinforcement_rate,",",
                 "forgetting_rate:",PARSER_forgetting_rate,",",
                 "interference_rate:",PARSER_interference_rate,",",
                 "logging:",PARSER_logging,
                 "}",seed_str,");"))
  ct$eval("PARSER.run()")
  
  #lexicon <- fromJSON(ct$eval("JSON.stringify(PARSER.getLexicon())"))
  base_weight <- as.numeric(ct$eval("PARSER.getWordStrength('A')"))+as.numeric(ct$eval("PARSER.getWordStrength('B')"))+as.numeric(ct$eval("PARSER.getWordStrength('C')"))
  target_weight <- as.numeric(ct$eval("PARSER.getWordStrength('ABC')")) + base_weight
  foil_weight <- base_weight
  return(list(model="PARSER", condition=condition, target=target_weight, foil=foil_weight))
}

#### function for running all models ####

run_parser_reps <- function(w){
  
  # vectors to store data
  runs <- list()
  length(runs) <- reps_per_condition  * 2 # 2 = number of conditions
  counter <- 1
  
  PARSER_forgetting_rate <<- w
  
  # run models
  for(z in 1:reps_per_condition){
    four_seq <- four_triple_sequence(reps_per_item_in_seq)
    
    runs[[counter]] <- run_PARSER_params('modeling/models/parser.js',four_seq, 'unseeded')
    counter <- counter + 1
    runs[[counter]] <- run_PARSER_params('modeling/models/parser.js',four_seq, 'seeded')
    counter <- counter + 1
  }
  
  experiment_data <- ldply(runs, data.frame)
  experiment_data$target = as.numeric(as.character(experiment_data$target))
  experiment_data$foil = as.numeric(as.character(experiment_data$foil))
  
  experiment_data$target <- sapply(experiment_data$target, function(w){if(w<=1){return(0)}else{return(w)}})
  experiment_data$foil <- sapply(experiment_data$foil, function(w){if(w<=1){return(0)}else{return(w)}})
  
  return(experiment_data)
}


#### calculate diff in conditions ####

experimentDataSample <- function(target, foil, gamma){
  p <- exp(target*gamma) / ( exp(target*gamma) + 5*exp(foil*gamma) )
  return(p)
}

calc_simulated_exp_performance <- function(run_data){
  run_data$p <- mapply(function(t,f){
    samp <- experimentDataSample(t,f, gamma_smax)
    return(samp)
  }, run_data$target, run_data$foil)
  
  return(run_data)
}

#### run! ####

sim_exp <- data.frame(w=numeric(),c=character(),p=numeric(),t=numeric(),f=numeric())

for(i in seq(from=0,to=0.4,by=0.02)){
  cat(paste('\rcurrent param value:',i))
  parser_run_data <- run_parser_reps(i)
  exp_perf <- calc_simulated_exp_performance(parser_run_data)
  sim_exp <- rbind(sim_exp, list(w=rep(i,reps_per_condition*2),condition=exp_perf$condition,p=exp_perf$p,target=exp_perf$target,foil=exp_perf$foil))
}

#### PARSER proportional forgetting model ####

run_mod_parser_reps <- function(w){
  
  # vectors to store data
  runs <- list()
  length(runs) <- reps_per_condition  * 2 # 2 = number of conditions
  counter <- 1
  
  PARSER_forgetting_rate <<- w
  
  # run models
  for(z in 1:reps_per_condition){
    four_seq <- four_triple_sequence(reps_per_item_in_seq)
    
    runs[[counter]] <- run_PARSER_params('modeling/models/parser-modified.js',four_seq, 'unseeded')
    counter <- counter + 1
    runs[[counter]] <- run_PARSER_params('modeling/models/parser-modified.js',four_seq, 'seeded')
    counter <- counter + 1
  }
  
  experiment_data <- ldply(runs, data.frame)
  experiment_data$target = as.numeric(as.character(experiment_data$target))
  experiment_data$foil = as.numeric(as.character(experiment_data$foil))
  
  experiment_data$target <- sapply(experiment_data$target, function(w){if(w<=1){return(0)}else{return(w)}})
  experiment_data$foil <- sapply(experiment_data$foil, function(w){if(w<=1){return(0)}else{return(w)}})
  
  return(experiment_data)
}

#### run! ####

sim_exp_modified_model <- data.frame(w=numeric(),c=character(),p=numeric(),t=numeric(),f=numeric())

for(i in seq(from=0,to=0.07,by=0.01)){
  cat(paste('\rcurrent param value:',i))
  parser_run_data_modified_model <- run_mod_parser_reps(i)
  exp_perf_modified_model <- calc_simulated_exp_performance(parser_run_data_modified_model)
  sim_exp_modified_model <- rbind(sim_exp_modified_model, list(w=rep(i,reps_per_condition*2),c=exp_perf_modified_model$condition,p=exp_perf_modified_model$p,t=exp_perf_modified_model$target,f=exp_perf_modified_model$foil))
}

save(sim_exp, sim_exp_modified_model, file="modeling/output/PARSER-variations.Rdata")
