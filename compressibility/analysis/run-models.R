#### package requirements ####
require(V8) # to run JS code
require(jsonlite) # to parse JSON output from JavaScript
require(plyr) # data storage manipulation

#### load script that can generate sequences ####
source('analysis/sequence-generators.R')

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

# MDLChunker parameters

MDL_perceptual_span <- 25
MDL_memory_span <- 150
MDL_logging <- "false"

# TRACX parameters

#### functions to run each model once ####

run_PARSER <- function(model, seq, condition) {

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
                 "});"))
  ct$eval("PARSER.run()")
  
  #lexicon <- fromJSON(ct$eval("JSON.stringify(PARSER.getLexicon())"))
  target_weight <- as.numeric(ct$eval("PARSER.getWordStrength('ABC')"))
  foil_weight <- as.numeric(ct$eval("PARSER.getWordStrength('DHL')"))
  # filter weights below 1.0
  if(target_weight < 1.0){ target_weight <- 0 }
  if(foil_weight < 1.0){ foil_weight <- 0 }
  return(list(model="PARSER", condition=condition, target=target_weight, foil=foil_weight))
}

run_MDLChunker <- function(model, seq, condition) {
  
  ct <- new_context();
  ct$source(model)
  ct$eval(paste0("MDLChunker.setup('",seq,"',{",
                 "memory_span:",MDL_memory_span,",",
                 "perceptual_span:",MDL_perceptual_span,",",
                 "logging:",MDL_logging,
                 "});"))
  ct$eval("MDLChunker.run()")
  
  #lexicon <- fromJSON(ct$eval("JSON.stringify(MDLChunker.getLexicon())"))
  target_weight <- as.numeric(ct$eval("MDLChunker.getCodeLengthForString('ABC')"))
  foil_weight <- as.numeric(ct$eval("MDLChunker.getCodeLengthForString('DHL')"))
  return(list(model="MDLChunker",condition=condition,target=target_weight, foil=foil_weight))
  
}

run_TRACX <- function(model, seq, condition) {
  
  ct <- new_context();
  ct$source('models/TRACX-dependencies/sylvester.js')
  ct$source('models/TRACX-dependencies/seedrandom-min.js')
  ct$source(model)
  ct$eval(paste0("TRACX.setTrainingData('",seq,"');"))
  ct$eval('TRACX.getInputEncodings();')
  ct$eval('TRACX.setTestData({Words:"ABC", PartWords: "", NonWords: "DHL"})')
  ct$eval('TRACX.setSingleParameter("randomSeed","")')
  ct$eval('TRACX.reset()')
  lexicon <- fromJSON(ct$eval('JSON.stringify(TRACX.runFullSimulation(function(i,m){}))'))
  target_weight <- as.numeric(lexicon$Words$mean)
  foil_weight <- as.numeric(lexicon$NonWords$mean)
  return(list(model="TRACX",condition=condition,target=target_weight, foil=foil_weight))
}


#### run all models ####

# vectors to store data
runs <- list()
length(runs) <- reps_per_condition * 3 * 2 # 3 = number of models,  2 = number of conditions
counter <- 1

# run models
for(i in 1:reps_per_condition){
  
  cat(paste('\r',i,'of',reps_per_condition))
  
  four_seq <- four_triple_sequence(reps_per_item_in_seq)
  one_seq <- one_triple_sequence(reps_per_item_in_seq)
  
  runs[[counter]] <- run_PARSER('models/parser.js',four_seq, 'four')
  counter <- counter + 1
  runs[[counter]] <- run_PARSER('models/parser.js',one_seq, 'one')
  counter <- counter + 1
  runs[[counter]] <- run_MDLChunker('models/mdlchunker.js',four_seq, 'four')
  counter <- counter + 1
  runs[[counter]] <- run_MDLChunker('models/mdlchunker.js',one_seq, 'one')
  counter <- counter + 1    
  runs[[counter]] <- run_TRACX('models/tracx.js',four_seq, 'four')
  counter <- counter + 1
  runs[[counter]] <- run_TRACX('models/tracx.js',one_seq, 'one')
  counter <- counter + 1
}

model_run_data <- ldply(runs, data.frame)
save(model_run_data, file='data/output/model_run_data.Rdata')