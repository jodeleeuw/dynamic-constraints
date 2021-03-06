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

# MDLChunker parameters

MDL_perceptual_span <- 25
MDL_memory_span <- 150
MDL_logging <- "false"

# TRACX parameters

#### functions to run each model once ####

run_PARSER <- function(model, seq, condition) {
  
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
  # filter weights below 1.0
  if(target_weight < 1.0){ target_weight <- 0 }
  if(foil_weight < 1.0){ foil_weight <- 0 }
  return(list(model="PARSER", condition=condition, target=target_weight, foil=foil_weight))
}

run_MDLChunker <- function(model, seq, condition) {
  
  if(condition=='seeded'){
    seq <- paste0(seed_sequence(100), seq)
  }
  
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
  foil_weight <- as.numeric(ct$eval("MDLChunker.getCodeLengthForString('ACB')")) +
    as.numeric(ct$eval("MDLChunker.getCodeLengthForString('BAC')")) +
    as.numeric(ct$eval("MDLChunker.getCodeLengthForString('BCA')")) +
    as.numeric(ct$eval("MDLChunker.getCodeLengthForString('CBA')")) +
    as.numeric(ct$eval("MDLChunker.getCodeLengthForString('CAB')"))
  foil_weight <- foil_weight / 5
  #memory <- fromJSON(ct$eval("MDLChunker.getMemory()"))
  #print(memory)
  return(list(model="MDLChunker",condition=condition,target=target_weight, foil=foil_weight))
  
}

# run_TRACX <- function(model, seq, condition) {
#   
#  # if(condition=='seeded'){
#  #   seq.prepend <- 
#  # }
#   
#   ct <- new_context();
#   ct$source('modeling/models/TRACX-dependencies/sylvester.js')
#   ct$source('modeling/models/TRACX-dependencies/seedrandom-min.js')
#   ct$source(model)
#   ct$eval(paste0("TRACX.setTrainingData('",seq,"');"))
#   ct$eval('TRACX.getInputEncodings();')
#   ct$eval('TRACX.setTestData({Words:"ABC", PartWords: "", NonWords: "DHL"})')
#   ct$eval('TRACX.setSingleParameter("randomSeed","")')
#   ct$eval('TRACX.reset()')
#   lexicon <- fromJSON(ct$eval('JSON.stringify(TRACX.runFullSimulation(function(i,m){}))'))
#   target_weight <- as.numeric(lexicon$Words$mean)
#   foil_weight <- as.numeric(lexicon$NonWords$mean)
#   return(list(model="TRACX",condition=condition,target=target_weight, foil=foil_weight))
# }


#### run all models ####

# vectors to store data
runs <- list()
length(runs) <- reps_per_condition * 2 * 2 # 1 = number of models,  2 = number of conditions
counter <- 1

# run models
for(i in 1:reps_per_condition){
  
  cat(paste('\r',i,'of',reps_per_condition))
  
  four_seq <- four_triple_sequence(reps_per_item_in_seq)
  
  runs[[counter]] <- run_PARSER('modeling/models/parser.js',four_seq, 'unseeded')
  counter <- counter + 1
  runs[[counter]] <- run_PARSER('modeling/models/parser.js',four_seq, 'seeded')
  counter <- counter + 1
  runs[[counter]] <- run_MDLChunker('modeling/models/mdlchunker.js', four_seq, 'unseeded')
  counter <- counter + 1
  runs[[counter]] <- run_MDLChunker('modeling/models/mdlchunker.js', four_seq, 'seeded')
  counter <- counter + 1
 
}

model_run_data <- ldply(runs, data.frame)
save(model_run_data, file='modeling/output/model_run_data.Rdata')