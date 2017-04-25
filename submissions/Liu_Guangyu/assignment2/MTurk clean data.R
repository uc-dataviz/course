#---
# April 24, 2017
# Assignment 2 -- clean data
#---
library(tidyr)
library(tidyverse)

# Read file
mTurk <- read_csv("submissions/Liu_Guangyu/assignment2/MTurk.csv")

# Select answer to each question and time spent on each question
T_Q <- select(mTurk, -contains("First"), -contains("Page"), -contains("Count"), -Q43, -mTurkCode)

# Rename variables
timeSpent <- select(T_Q, t = contains("Last"))
question <- select(T_Q, -contains("Last")) %>% 
  select(q = contains("Q"))

# Split data of two tasks
task1 <- select(question, c(q1:q8))
task2 <- select(question, c(q9:q20))

# Answer to task 1
answer1 <- c(11, 11, 12, 12, 12, 12, 13, 13)
answer2 <- rep(c("Increase", "Decrease", "Hard to tell"), 4)

# Compute correctness for each task
error1 <- task1
for (i in seq_along(task1)){
  error1[[i]] <- task1[[i]] - answer1[i]
}

error2 <- task2
for (i in seq_along(task2)){
  error2[[i]] <- (task2[[i]] == answer2[i])
}

# Export cleaned data
cleanedData <- bind_cols(error1, error2, timeSpent)
write.csv(cleanedData, file = "submissions/Liu_Guangyu/assignment2/cleanedData.csv")
