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
library(grid)

# Gets nes data.
nes <- read_dta("nes2008.dta")

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
         party_factor = factor(party, labels = c("dem", "rep", "other")),
         gender_factor = factor(gender, labels = c("famale", "male")),
         educ_years = cut(educ, breaks = years, labels = educ_years_labels),
         age_intervals = cut(age, breaks = ages_intervals_vec, labels = ages_labels)) %>% 
  select(-partyid3) %>%
  na.omit %>% 
  write_csv("data/biden.csv")

# Graph.
# Theme configuration.

# Configure Theme
gen_theme <- function() {
  theme(
    plot.background = element_rect(fill = "#E2E2E3", colour = "#E2E2E3"),
    panel.background = element_rect(fill = "#E2E2E3"),
    axis.text = element_text(colour = "#E7A922", family = "Impact"),
    plot.title = element_text(colour = "#6699CC", face = "bold", size = 15, vjust = 1, family = "Impact"),
    axis.title = element_text(colour = "#6699CC", face = "bold", size = 12, family = "Impact"),
    panel.grid.major.x = element_line(colour = "#E7A922"),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    strip.text = element_text(family = "Impact", colour = "white"),
    strip.background = element_rect(fill = "#E7A922"),
    axis.ticks = element_line(colour = "#E7A922")
  )
}

# By party
graph_1 <- ggplot(data = biden, stat = "prop") +
  facet_grid(age_intervals ~ gender_factor) +
  geom_bar(aes(x = party_factor, fill = biden_interval), position = "fill") + 
  coord_flip() + 
  ylab("Feelings Range") + xlab("Political Party") + 
  ggtitle("Feelings about Joe Biden by gender, political party, and age") + 
  scale_fill_manual(values=c("#6699CC", "#99CCFF", "#FFCC66", "#FF6600")) +
  gen_theme()

ggsave("./graphics/by_party.png", scale = 1)

# By years of education
graph_2 <- ggplot(data = biden, stat = "prop") +
  facet_grid(age_intervals ~ gender_factor) +
  geom_bar(aes(x = educ_years, fill = biden_interval), position = "fill") + 
  coord_flip() + 
  ylab("Feelings Range") + xlab("Years of Education") + 
  ggtitle("Feelings about Joe Biden by gender, years of education, and age") + 
  scale_fill_manual(values=c("#6699CC", "#99CCFF", "#FFCC66", "#FF6600")) +
  gen_theme()

ggsave("./graphics/by_educ_years.png", scale = 1)

