# Script that performs a exploratory data analysis.
library(tidyverse)
library(ggplot2)

# Loads hospitals.csv file. 
tidy_data <- read.csv(file = "./data/tidy_data/tidy_data.csv", stringsAsFactors = FALSE) %>%
    tbl_df() 

# Generating plot of democratic satisfaction by several variables.
tidy_data %>%
    ggplot(aes(democracy_satisfaction, fill = gender)) +
    geom_bar(na.rm = TRUE) +
        labs(title = "Democracy satisfaction by gender",
         x = "Answer to the statement: I feel satisfied with democracy",
         y = "Count") 
    ggsave("./graphics/demo_satisf_gender.png")
 
tidy_data %>%
    ggplot(aes(democracy_satisfaction, fill = social_class)) +
    geom_bar() +
    labs(title = "Democracy satisfaction by social class and marital status",
         x = "Answer to the statement: I feel satisfied with democracy",
         y = "Count") +
    facet_wrap(~ marital_status) +
    coord_flip()
    ggsave("./graphics/demo_satisf_class_marital.png")

tidy_data %>%
    ggplot(aes(democracy_satisfaction, fill = country_economy)) +
    geom_bar() +
    labs(title = "Democracy satisfaction by economic situation",
         x = "Answer to the statement: I feel satisfied with democracy",
         y = "Count")
ggsave("./graphics/demo_satisf_economy.png")

tidy_data %>%
    ggplot(aes(democracy_satisfaction, age)) +
    geom_boxplot() +
    labs(title = "Democracy satisfaction by age",
         x = "Answer to the statement: I feel satisfied with democracy",
         y = "Age")
ggsave("./graphics/demo_satisf_age.png")



