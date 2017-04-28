#---
# Assignment 2
# Due: April 28, 2017
#---

library(tidyr)
library(tidyverse)
library(graphics)
library(dplyr)
library(knitr)

#---------
# Plotting graphs for task 1
#---------
set.seed(428)

# Generate two random N-item data frames, with x and y are normal distributed continuous variables,
# z is a categorical variable with 4 categories, while each category has nearly equal number of items
N1 <- 46
N2 <- 50
rData_1 <- data.frame(x = abs(rnorm(N1)), y = abs(rnorm(N1)), z = c(1:N1) %% 4)
rData_2 <- data.frame(x = abs(rnorm(N2)), y = abs(rnorm(N2)), z = c(1:N2) %% 4)
rData_1$z <- factor(as.factor(rData_1$z), labels = c("A", "B", "C", "D"))
rData_2$z <- factor(as.factor(rData_2$z), labels = c("A", "B", "C", "D"))

rData_1 %>% 
  group_by(z) %>% 
  count()
rData_2 %>% 
  group_by(z) %>% 
  count()

# Differentiate by color (saturation)
color_1 <- ggplot(rData_1) +
  geom_point(aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/color_1.png")
plot(color_1)
dev.off()

color_2 <- ggplot(rData_2) +
  geom_point(aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/color_2.png")
plot(color_2)
dev.off()

# Differentiation by shape
rData_1$x <- abs(rnorm(N1))
rData_1$y <- abs(rnorm(N1))
rData_2$x <- abs(rnorm(N2))
rData_2$y <- abs(rnorm(N2))

shape_1 <- ggplot(rData_1) +
  geom_point(aes(x = x, y = y, shape = z), size = 4) +
  labs(x = "", y = "", title  = "" ,shape = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shape_1.png")
plot(shape_1)
dev.off()

shape_2 <- ggplot(rData_2) +
  geom_point(aes(x = x, y = y, shape = z), size = 4) +
  labs(x = "", y = "", title  = "", shape = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shape_2.png")
plot(shape_2)
dev.off()

# Differentiation by size
rData_1$x <- abs(rnorm(N1))
rData_1$y <- abs(rnorm(N1))
rData_2$x <- abs(rnorm(N2))
rData_2$y <- abs(rnorm(N2))

size_1 <- ggplot(rData_1) +
  geom_point(aes(x = x, y = y, size = z)) +
  labs(x = "", y = "", title = "", size = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  coord_flip()
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/size_1.png")
plot(size_1)
dev.off()

size_2 <- ggplot(rData_2) +
  geom_point(aes(x = x, y = y, size = z)) +
  labs(x = "", y = "", title = "", size = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  coord_flip()
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/size_2.png")
plot(size_2)
dev.off()

# Differentiate by shade
rData_1$x <- abs(rnorm(N1))
rData_1$y <- abs(rnorm(N1))
rData_2$x <- abs(rnorm(N2))
rData_2$y <- abs(rnorm(N2))

shade_1 <- ggplot(rData_1) +
  geom_point(aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_brewer(palette = "Blues")
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shade_1.png")
plot(shade_1)
dev.off()

shade_2 <- ggplot(rData_2) +
  geom_point(aes(x = x, y = y, color = z), size = 4) +
  labs(x = "", y = "", title = "", color = "") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_brewer(palette = "Blues")
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shade_2.png")
plot(shade_2)
dev.off()

#-----------
# Plotting graphs for task 2
#-----------

# Generate a random N-item data frame, with x and y are normal distributed continuous variables,
# class is a categorical variable with 4 categories, while each category has nearly equal number of items
N <- 50
rData <- data.frame(x = rnorm(N), y = rnorm(N), class = c(1:N) %% 4)
rData$class <- factor(as.factor(rData$class), labels = c("A", "B", "C", "D"))

# General trend by color
# Positive association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "A", 0.6*rData$x + 0.3*rData$y, rData$y)
ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "x", y = "y", title = "For class A, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/color_slope_1.png")
plot(color_slope_1)
dev.off()

# Negative association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "B", -0.6*rData$x + 0.3*rData$y, rData$y)
color_slope_2 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "x", y = "y", title = "For class B, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/color_slope_2.png")
plot(color_slope_2)
dev.off()

# None association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "C", 0.3*rData$y, rData$y)
color_slope_3 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "x", y = "y", title = "For class C, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/color_slope_3.png")
plot(color_slope_3)
dev.off()

# General trend by shape
# Positive association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "D", 0.6*rData$x + 0.3*rData$y, rData$y)

shape_slope_1 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, shape = class), size = 4) +
  labs(x = "x", y = "y", title = "For class D, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shape_slope_1.png")
plot(shape_slope_1)
dev.off()

# Negative Association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "A", -0.6*rData$x + 0.3*rData$y, rData$y)
shape_slope_2 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, shape = class), size = 4) +
  labs(x = "x", y = "y", title = "For class A, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shape_slope_2.png")
plot(shape_slope_2)
dev.off()

# None association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "B", 0.3*rData$y, rData$y)
shape_slope_3 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, shape = class), size = 4) +
  labs(x = "x", y = "y", title = "For class B, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shape_slope_3.png")
plot(shape_slope_3)
dev.off()

# General trend by size
# Positive association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "C", 0.6*rData$x + 0.3*rData$y, rData_1$y)

size_slope_1 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, size = class)) +
  labs(x = "x", y = "y", title = "For class C, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/size_slope_1.png")
plot(size_slope_1)
dev.off()

# Negative association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "D", -0.6*rData$x + 0.3*rData$y, rData$y)
size_slope_2 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, size = class)) +
  labs(x = "x", y = "y", title = "For class D, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/size_slope_2.png")
plot(size_slope_2)
dev.off()

# None association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "A", 0.3*rData$y, rData$y)
size_slope_3 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, size = class)) +
  labs(x = "x", y = "y", title = "For class A, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL)
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/size_slope_3.png")
plot(size_slope_3)
dev.off()

# General trend by shade
# Positive association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "B", 0.6*rData$x + 0.3*rData$y, rData$y)

shade_slope_1 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "", y = "", title = "For class B, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_brewer(palette = "Blues")
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shade_slope_1.png")
plot(shade_slope_1)
dev.off()

# Negative association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "C", -0.6*rData$x + 0.3*rData$y, rData$y)
shade_slope_2 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "", y = "", title = "For class C, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_brewer(palette = "Blues")
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shade_slope_2.png")
plot(shade_slope_2)
dev.off()

# None association
rData$x <- rnorm(N)
rData$y <- rnorm(N)
rData$y <- ifelse(rData$class == "D", 0.3*rData$y, rData$y)
shade_slope_3 <- ggplot(rData) +
  geom_point(aes(x = x, y = y, color = class), size = 4) +
  labs(x = "", y = "", title = "For class D, how will y change when x increases?") +
  scale_x_continuous(breaks = NULL) +
  scale_y_continuous(breaks = NULL) +
  scale_color_brewer(palette = "Blues")
png(filename = "submissions/Liu_Guangyu/assignment2/graphs/shade_slope_3.png")
plot(shade_slope_3)
dev.off()

#------------
# Cleanning data
#------------

# Read file
mTurk <- read_csv("submissions/Liu_Guangyu/assignment2/MTurk.csv")

# Select answer to each question and time spent on each question
T_Q <- select(mTurk, -contains("First"), -contains("Page"), -contains("Count"), -Q43, -mTurkCode)

# Rename variables
timeSpent <- select(T_Q, t = contains("Last"))
question <- select(T_Q, -contains("Last")) %>% 
  select(q = contains("Q"))

# Answer to task 1
answer1 <- c(11, 13, 12, 12, 11, 13, 12, 12)
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

#-------------
# Analyzing data
#-------------

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

#---
# Task2 -- general trend
#---
task2 <- select(mTurkData, num_range("q", 9:20)) %>% 
  gather(key = "channel", value = "answer") %>% 
  mutate(channel = ifelse(channel == "q9" | channel == "q10" | channel == "q11", "color",
                          ifelse(channel == "q12" | channel == "q13" | channel == "q14", "shape",
                                 ifelse(channel == "q15" | channel == "q16" | channel == "q17", "size", "shading"))))

# Now, correct answer is coded as TRUE (1), wrong answer is coded as FALSE (0)
# Recode correct answer as 0 point deviates from the correct answer, and wrong answer as 1 point deviates from the correct answer
# so that the graph can be read the same as task 1
task2$answer <- 1 - task2$answer

time2 <- select(mTurkData, num_range("t", 9:20)) %>% 
  gather(key = "channel", value = "timeSpent") %>% 
  mutate(channel = ifelse(channel == "t9" | channel == "t10" | channel == "t11", "color",
                          ifelse(channel == "t12" | channel == "t13" | channel == "t14", "shape",
                                 ifelse(channel == "t15" | channel == "t16" | channel == "t17", "size", "shading"))),
         centeredT = timeSpent - mean(timeSpent, na.rm = TRUE))

# Calculate the mean, min, max, and sd of the deviation
task2_sum <- task2 %>% 
  group_by(channel) %>% 
  summarize(mean = mean(answer, na.rm = TRUE), 
            #            min = min(answer, na.rm = TRUE), 
            #            max = max(answer, na.rm = TRUE), 
            sd = sd(answer, na.rm = TRUE))

time2_sum <- time2 %>% 
  group_by(channel) %>% 
  summarize(mean = mean(centeredT, na.rm = TRUE), 
            #            min = min(centeredT, na.rm = TRUE), 
            #           max = max(centeredT, na.rm = TRUE), 
            sd = sd(centeredT, na.rm = TRUE))

# Merge data and reorder factors
task2_merge <- bind_rows("Answer" = task2_sum, "Time" = time2_sum, .id = "group")
task2_merge$channel <- reorder(as.factor(task2_merge$channel), task2_merge$mean)
task2_merge$group <- factor(task2_merge$group, 
                            levels = c("Time", "Answer"), 
                            labels = c("Time", "Answer"))


# Plot the answer and time of each channel. 
# The point in the middle denotes the mean of each channel. Answer close to zero means more accurate.
# The dotted line denotes the range of the deviation from the correct answer/grand mean.
# The solid line denotes [mean - sd, mean + sd]
ggplot(task2_merge, aes(x = group, y = mean, color = group)) +
  #  geom_linerange(aes(ymin = min, ymax = max), size = 1, linetype = 3) +
  geom_linerange(aes(ymin = mean - sd, ymax = mean + sd), size = 1) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0, color = "ivory3", linetype = 2, size = 0.8) +
  coord_flip() +
  facet_grid(channel~.) +
  labs(y = "Deviation",
       x = NULL,
       title = "Fig 2 - Telling general trends represented by different channels") +
  scale_color_manual(values = c("Time" = "skyblue1", "Answer" = "coral1")) +
  theme(legend.position = "none")

# T-test for every adjacent channels
# Define a function to add t-test results to a dataframe
add_result <- function(df, result, test){
  df <- add_row(df, test = test, stat = result$statistic, p_value = result$p.value)
}

# New dataframe
ttest2 <- data.frame(test = character(0), stat = numeric(0), p_value = numeric(0))

# T-tests and adding results
result <- oneway.test(answer ~ channel, data = task2)
ttest2 <- add_result(ttest2, result, "Answer: one-way ANOVA")

result <- oneway.test(centeredT ~ channel, data = time2)
ttest2 <- add_result(ttest2, result, "Time: one-way ANOVA")

kable(ttest2, format = "markdown", col.names = c("Test", "F-stat", "p-value"),
      caption = "One-way ANOVA output")