# load required libraries ####
require(plyr)
require(runjags)

# load data file ####
data.all <- read.csv('data/sl_letters_all_data.csv')

# extract critical trials test data & convert types ####
data.test <- subset(data.all, test_type == 'critical' | (seq_condition=='unknown' & test_type == 'other'), c(participant, seq_condition, key_press, correct_choice))
data.test$correct_choice <- as.numeric(as.character(data.test$correct_choice))
data.test$key_press <- as.numeric(as.character(data.test$key_press))
data.test$correct <- with(data.test, key_press == correct_choice + 48)

# remove duplicate subjects who took the test more than once ####
# they probably did this by refreshing the browser page at the end of the experiment
# after missing the instructions on how to complete the HIT on mturk
trial.count.by.subject <- ddply(data.test, .(participant, seq_condition), function(s)with(s, c(count=nrow(s))))

# total subject count
nrow(trial.count.by.subject)

# count of subjects in each condition
table(trial.count.by.subject$seq_condition)

# check if a subject didn't complete the expected number of test trials
trial.count.by.subject$bad <- mapply(function(cond,count){
  if(cond=='known') { return(count != 1) }
  if(cond=='unknown') { return(count != 4) }
}, trial.count.by.subject$seq_condition, trial.count.by.subject$count)

subject.in.both.conditions <- as.data.frame(table(trial.count.by.subject$participant))

bad.subjects <- c(subset(trial.count.by.subject, bad==T)$participant, subset(subject.in.both.conditions, Freq>1)$Var1)

data.test.filtered <- subset(data.test, !participant%in%bad.subjects)

# summarize the data at the subject level ####
data.summarized <- ddply(data.test.filtered, .(participant, seq_condition), function(s){
  return(c(
    correct = sum(s$correct),
    N = nrow(s),
    p = sum(s$correct) / nrow(s)
  ))
})

save(data.summarized, file="data/output/experiment-data-summary.Rdata")

# run bayesian model in JAGS ####

modeldata <- list(
  y = as.numeric(data.summarized$correct),
  cond = as.numeric(data.summarized$seq_condition),
  Ntotal = nrow(data.summarized),
  N = data.summarized$N
)

jags.result <- run.jags('jags model/jags-model.txt', monitor = c('baseline','diff'), burnin=5000, sample=20000, n.chains=3, data = modeldata)

save(jags.result, file="data/output/jags.experiment.result.Rdata")

