# Libraries
library(tidyverse)
library(modelr)
library(ggplot2)
theme_set(theme_bw())

# Reading data.
raw_data <- read.csv(file = "./data/tidy_data/tidy_data.csv", stringsAsFactors = FALSE) %>%
    tbl_df() 

# Recoding variables.
raw_data$democracy_satisfaction[raw_data$democracy_satisfaction == "Strongly agree"] <- 1
raw_data$democracy_satisfaction[raw_data$democracy_satisfaction == "Agree"] <- 1
raw_data$democracy_satisfaction[raw_data$democracy_satisfaction == "Desagree"] <- 0
raw_data$democracy_satisfaction[raw_data$democracy_satisfaction == "Strongly desagree"] <- 0

raw_data$gender[raw_data$gender == "Male"] <- 0
raw_data$gender[raw_data$gender == "Female"] <- 1

# Logistic model
raw_data$democracy_satisfaction <- as.integer(raw_data$democracy_satisfaction)
raw_data$gender <- as.integer(raw_data$gender)

satis_age <- glm(democracy_satisfaction ~ age, data = raw_data, family = binomial)

ggplot(raw_data, aes(age, democracy_satisfaction)) +
    geom_point() +
    geom_smooth(method = "glm", method.args = list(family = "binomial"),
                se = FALSE)
ggsave("./graphics/age_satisfaction_model.png")

# Generating an evenly spaced grid of values.
dem_satis_age <- raw_data %>%
    data_grid(age)

logit2prob <- function(x){
    exp(x) / (1 + exp(x))
}

dem_satis_age <- dem_satis_age %>%
    add_predictions(satis_age) %>%
    mutate(pred = logit2prob(pred))
dem_satis_age

ggplot(dem_satis_age, aes(age, pred)) +
    geom_line() +
    labs(title = "Age and Satisfaction with Democracy",
         y = "Predicted Satisfaction with Democracy")
ggsave("./graphics/predicted_age_satisfaction_model.png")

# Testing accuracy

raw_split <- resample_partition(raw_data, c(test = 0.3, train = 0.7))
map(raw_split, dim)


train_model <- glm(democracy_satisfaction ~ age, data = raw_split$train,
                   family = binomial)
summary(train_model)

#Test accuracy
x_test_accuracy <- raw_split$test %>%
    tbl_df() %>%
    add_predictions(train_model) %>%
    mutate(pred = logit2prob(pred),
           pred = as.numeric(pred > .5))

mean(x_test_accuracy$democracy_satisfaction == x_test_accuracy$pred, na.rm = TRUE)
