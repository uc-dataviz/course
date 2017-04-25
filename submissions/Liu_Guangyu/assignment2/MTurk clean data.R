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

# Answer to task 1
answer1 <- c(11, 11, 12, 12, 12, 12, 13, 13)
answer2 <- rep(c("Increase", "Decrease", "Hard to tell"), 4)

# Merge data
mergedData <- bind_cols(question, timeSpent)

# Delete guessing answers
# For multiple choice questions, if a respondent choose the same option for all 12 questions, 
# he/she is regarded as guessing answers. All data from this respondent is removed from the dataset
rownum = integer()
for (r in 1:nrow(mergedData)){
  guessAnswer <- TRUE
  for (i in 10:20){
    if (mergedData[r,][i] != mergedData[r,][i-1]){
      guessAnswer <- FALSE
      break
      }
  }
  if (guessAnswer){
    rownum <- c(rownum, r)
  }
}
mergedData <- mergedData[-rownum,]

# Remove unreasonable time
# Time spent on a question is regarded as unreasonably long if it is more than 60 seconds.
# Time spent on the first eight questions (counting points) is regared as unreasonably short if it is less than 5 sec.
# Those data is converted as missing value
for (i in 21:40){
  for (r in 1:nrow(mergedData)){
    if (mergedData[r,][i] > 60 | (mergedData[r,][i] < 5 & i < 29)){
      mergedData[r,][i] = NA
    }
  }
}

# Compute correctness for each task
# First task
for (i in 1:8){
  mergedData[[i]] <- mergedData[[i]] - answer1[i]
}
# Second task
for (i in 9:20){
  mergedData[[i]] <- (mergedData[[i]] == answer2[i-8])
}

# Export cleaned data
write.csv(mergedData, file = "submissions/Liu_Guangyu/assignment2/cleanedData.csv")
