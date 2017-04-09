###############################################################
# Data Vizualization
# Assigment One
# Camacho Jonathan E.
###############################################################
# This script accomplish the following tasks:
# Gets "nes" data. 
###############################################################

# Libraries necessary for the script to run. 
library(tidyverse)
library(haven)

# Gets nes data.
nes <- read_dta("data/nes2008.dta")

# Prep biden related variables
biden <- nes %>%
  select(biden_therm_post, gender, partyid3, age, educ_r) %>%
  mutate_each(funs(ifelse(is.nan(.), NA, .))) %>%
    mutate(gender = gender - 1, party = ifelse(partyid3 == 1, 1, ifelse(partyid3 == 3, 2, 0))) %>% 
    mutate_each(funs(as.integer)) %>%
    rename(biden = biden_therm_post,
         female = gender,
         educ = educ_r) %>%
  select(-partyid3) %>%
  na.omit
#   write_csv("data/biden.csv")