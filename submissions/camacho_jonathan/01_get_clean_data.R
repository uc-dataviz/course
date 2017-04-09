# Libraries necessary for the script to run. 
library(tidyverse)

# P12TG.B is the economic variable
# P26STM if the elections were clean

# Reading data and renaming variables.
raw_data <- read.csv("./data/latinobarometer_ven_2015.csv", stringsAsFactors = FALSE) %>% 
    tbl_df() %>%
    select(X, S13, S12, S11, S6, P27ST, P3STGBS, P13ST.A, P26STM) %>%
    rename(
        code = X, 
        country_economy = P3STGBS,
        democracy_satisfaction = P13ST.A,
        elections_fairnes = P26STM,
        political_orientation = P27ST,
        social_class = S6,
        marital_status = S11,
        gender = S12,
        age = S13
        )

# Recoding variables.       
raw_data$country_economy[raw_data$country_economy == 1] <- "Very good"
raw_data$country_economy[raw_data$country_economy == 2] <- "Good"
raw_data$country_economy[raw_data$country_economy == 3] <- "About average"
raw_data$country_economy[raw_data$country_economy == 4] <- "Bad"
raw_data$country_economy[raw_data$country_economy == 5] <- "Very bad"

raw_data$democracy_satisfaction[raw_data$democracy_satisfaction == 1] <- "Strongly agree"
raw_data$democracy_satisfaction[raw_data$democracy_satisfaction == 2] <- "Agree"
raw_data$democracy_satisfaction[raw_data$democracy_satisfaction == 3] <- "Desagree"
raw_data$democracy_satisfaction[raw_data$democracy_satisfaction == 4] <- "Strongly desagree"

raw_data$social_class[raw_data$social_class == 1] <- "High"
raw_data$social_class[raw_data$social_class == 2] <- "Uper-middle"
raw_data$social_class[raw_data$social_class == 3] <- "Middle"
raw_data$social_class[raw_data$social_class == 4] <- "Lower-middle"
raw_data$social_class[raw_data$social_class == 5] <- "Low"

raw_data$marital_status[raw_data$marital_status == 1] <- "Married/living with partner"
raw_data$marital_status[raw_data$marital_status == 2] <- "Separated"
raw_data$marital_status[raw_data$marital_status == 3] <- "Separated/divorced/widowed"

raw_data$gender[raw_data$gender == 1] <- "Male"
raw_data$gender[raw_data$gender == 2] <- "Female"

# Removing NAs
raw_data <- raw_data[complete.cases(raw_data),]

# Write tidy data set to disk. 
write.csv(raw_data, "./data/tidy_data/tidy_data.csv")
 
