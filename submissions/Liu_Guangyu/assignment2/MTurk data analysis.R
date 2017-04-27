#---
# April 25, 2017
# Assignment 2 -- Data analysis
#---

library(tidyr)
library(tidyverse)
library(dplyr)

mTurkData <- read.csv("submissions/Liu_Guangyu/assignment2/cleanedData.csv")

#---
# Task1 -- counting points
#---
task1 <- select(mTurkData, num_range("q", 1:8)) %>% 
  gather(key = "channel", value = "answer") %>% 
  mutate(channel = ifelse(channel == "q1" | channel == "q8", "color",
                          ifelse(channel == "q2" | channel == "q7", "shading",
                                 ifelse(channel == "q3" | channel == "q6", "size", "shape"))))

time1 <- select(mTurkData, num_range("t", 1:8)) %>% 
  gather(key = "channel", value = "timeSpent") %>% 
  mutate(channel = ifelse(channel == "t1" | channel == "t8", "color",
                          ifelse(channel == "t2" | channel == "t7", "shading",
                                 ifelse(channel == "t3" | channel == "t6", "size", "shape"))),
         centeredT = timeSpent - mean(timeSpent, na.rm = TRUE))

# Calculate the mean, min, max, and sd of the deviation
task1_sum <- task1 %>% 
  group_by(channel) %>% 
  summarize(mean = mean(answer, na.rm = TRUE), 
            min = min(answer, na.rm = TRUE), 
            max = max(answer, na.rm = TRUE), 
            sd = sd(answer, na.rm = TRUE))

time1_sum <- time1 %>% 
  group_by(channel) %>% 
  summarize(mean = mean(centeredT, na.rm = TRUE), 
            min = min(centeredT, na.rm = TRUE), 
            max = max(centeredT, na.rm = TRUE), 
            sd = sd(centeredT, na.rm = TRUE))

# Merge data and reorder factors
task1_merge <- bind_rows("Answer" = task1_sum, "Time" = time1_sum, .id = "group")
task1_merge$channel <- reorder(as.factor(task1_merge$channel), task1_merge$mean)
task1_merge$group <- factor(task1_merge$group, 
                            levels = c("Time", "Answer"), 
                            labels = c("Time", "Answer"))


# Plot the answer and time of each channel. 
# The point in the middle denotes the mean of each channel. Answer close to zero means more accurate.
# The dotted line denotes the range of the deviation from the correct answer/grand mean.
# The solid line denotes [mean - sd, mean + sd]
ggplot(task1_merge, aes(x = group, y = mean, color = group)) +
  geom_linerange(aes(ymin = min, ymax = max), size = 1, linetype = 3) +
  geom_linerange(aes(ymin = mean - sd, ymax = mean + sd), size = 1) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0, color = "ivory3", linetype = 2, size = 0.8) +
  coord_flip() +
  facet_grid(channel~.) +
  labs(y = "Deviation",
       x = NULL,
       title = "Fig 1 - Differentiating points represented by different channels") +
  scale_color_manual(values = c("Time" = "skyblue1", "Answer" = "coral1")) +
  theme(legend.position = "none")

# T-test for every adjacent channels
# Define a function to add t-test results to a dataframe
add_result <- function(df, result, test){
  df <- add_row(df, test = test, t_stat = result$statistic, p_value = result$p.value)
}

# New dataframe
ttest1 <- data.frame(test = character(0), t_stat = numeric(0), p_value = numeric(0))

# T-tests and adding results
result <- t.test(answer ~ channel, data = filter(task1, channel == "color" | channel == "shape"))
ttest1 <- add_result(ttest1, result, "Answer: color~shape")

result <- t.test(answer ~ channel, data = filter(task1, channel == "shape" | channel == "shading"))
ttest1 <- add_result(ttest1, result, "Answer: shape~shading")

result <- t.test(answer ~ channel, data = filter(task1, channel == "shading" | channel == "size"))
ttest1 <- add_result(ttest1, result, "Answer: shading~size")

result <- t.test(centeredT ~ channel, data = filter(time1, channel == "color" | channel == "shape"))
ttest1 <- add_result(ttest1, result, "Time: color~shape")

result <- t.test(centeredT ~ channel, data = filter(time1, channel == "shape" | channel == "shading"))
ttest1 <- add_result(ttest1, result, "Time: shape~shading")

result <- t.test(centeredT ~ channel, data = filter(time1, channel == "shading" | channel == "size"))
ttest1 <- add_result(ttest1, result, "Time: shading~size")

kable(ttest1, format = "markdown", col.names = c("Test", "t-stat", "p-value"))
