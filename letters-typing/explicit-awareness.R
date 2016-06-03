# load the data frames from each coder ####

data.c1 <- read.csv('data/debrief-coded/coder-1.csv')
data.c2 <- read.csv('data/debrief-coded/coder-2.csv')

data.c1[is.na(data.c1)] <- 0
data.c2[is.na(data.c2)] <- 0

# count percent agreement
agree <- data.c1 == data.c2
sum(agree[,3:7])/ (5*142) * 100 # percent agreement

# only need to do this once to create data file to check ####
# rows.agree <- apply(agree, 1, all)
# data.to.check <- data.c1[!rows.agree,]
# write.csv(data.to.check, file='data-to-check.csv')

# load data that arbitrates mismatch
data.c3 <- read.csv('data/debrief-coded/coder-3.csv')

# merge 
data.merged <- data.c1
data.merged[data.merged$subject%in%data.c3$subject,] <- data.c3

# how many subjects identified NIW?
sum(data.merged$NIW)

# load p.learn data
load('data/subject-p-learn.Rdata')

# fix the subject ID issue caused by subject who failed to record a single correct response
data.merged.filter <- subset(data.merged, subject!=85)
data.merged.filter$subject <- as.numeric(factor(data.merged.filter$subject))

subject.p.learner <- subset(subject.p.learner, T, c(subject, p))

data.merged.filter <- merge(data.merged.filter, subject.p.learner)

fit <- glm(NIW~p, data=data.merged.filter, family=binomial())
summary(fit)
plot(fit)
plot(NIW~p, data=data.merged.filter)
curve(predict(fit,data.frame(p=x),type="resp"),add=TRUE)

predict(fit, data.frame(p=c(0,1)),type='resp')
exp(fit$coefficients)
