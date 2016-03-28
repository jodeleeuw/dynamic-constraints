# load all raw data
data.raw <- read.csv2('data/all-raw-data.csv', quote="'")

# remove subject 9999, which was the researcher testing the experiment
data.all <- subset(data.raw, subject!=9999)

# save the filtered data for loading from other scripts
write.csv(data.all, file="data/filtered-data.csv")
