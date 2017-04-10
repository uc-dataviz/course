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
# Vectors for variables factorization.
years <- c(0, 5, 8, 12, 17)
educ_years_labels <-c("elementary","middle-school","high-school","college")

ages_intervals_vec <- c(18, 25, 35, 45, 93)
ages_labels <- c("young", "young-adult", "adult", "third-age")

int_biden <- c(0, 25, 50, 75, 100)
biden_labels <- c("frozen", "cold", "warm", "hot")

# Transforming variables. 
biden <- nes %>%
  select(biden_therm_post, gender, partyid3, age, educ_r) %>%
  mutate_each(funs(ifelse(is.nan(.), NA, .))) %>%
  mutate_each(funs(as.integer)) %>%
  rename(biden = biden_therm_post, educ = educ_r) %>%
  mutate(gender = gender - 1,
         biden_interval = cut(biden, breaks = int_biden, labels = biden_labels), 
         party = ifelse(partyid3 == 1, 1, ifelse(partyid3 == 3, 2, 0)),
         educ_years = cut(educ, breaks = years, labels = educ_years_labels),
         age_intervals = cut(age, breaks = ages_intervals_vec, labels = ages_labels)) %>% 
  select(-partyid3) %>%
  na.omit
#write_csv("data/biden.csv")

# Graph.
ggplot(data = biden) +
  facet_grid( ~ gender) +
  geom_bar(aes(x = party, fill = biden_interval ), position = "fill") + 
  coord_flip() + 
  ylab("Y LABEL") + xlab("X LABEL") + 
  ggtitle("TITLE OF THE FIGURE")
# # 
# # ggsave("./plots/binomial_distribution_by_cat.png", scale = 1)
