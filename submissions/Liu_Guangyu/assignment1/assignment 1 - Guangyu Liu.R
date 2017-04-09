#---
# title: Assignment 1
# author: Guangyu Liu
# due date: April 10, 2017
#---

library(tidyr)
library(tidyverse)

# Read data
Biden <- read.csv(file = "assignments/data/biden.csv")

# Recode categorical variables
## Recode female
Biden$female <- factor(Biden$female, levels = c(0, 1), labels = c("male", "female"))

## Recode party
Biden$party[dem == 1] <- "Democratic"
Biden$party[rep == 1] <- "Republican"
Biden$party[dem == 0 & rep == 0] <- "Other"
Biden$party <- factor(Biden$party, levels = c("Democratic", "Other", "Republican"))

## Recode educ
Biden$educ_cat <- cut(educ, 
                      breaks = c(0, 12, 13, 16, 17, Inf),
                      labels = c("less than HS", "HS degree", "some college", "college degree", "graduate"),
                      right = FALSE)

## Recode biden
Biden$biden_cat <- cut(biden,
                       breaks = c(-Inf, 26, 51, 76, Inf),
                       labels = c("coldest", "colder", "warmer", "warmest"),
                       right = FALSE)

## Recode age
Biden$age_cat <- cut(age, 
                     breaks = c(-Inf, 33, 48, 63, 78, Inf), 
                     labels = c("18-32", "33-47", "48-62", "63-77", "78+"),
                     right = FALSE)

# Percentage of attitude within each category
biden_perc <- Biden %>%
  group_by(female, party, biden_cat) %>% 
  summarize(freq = n()) %>% 
  mutate(perc = round(freq/sum(freq)*100, 2))

# Split biden_perc into two groups: cold and warm
cold <- filter(biden_perc, biden_cat == "coldest" | biden_cat == "colder")
warm <- filter(biden_perc, biden_cat == "warmer" | biden_cat == "warmest")

# Negate the percentage of cold attitude, reverse order
cold$perc = -cold$perc
warm$biden_cat <- ordered(warm$biden_cat, levels = rev(levels(warm$biden_cat)))

# Visualization
bar_thermo <- ggplot() +
  aes(x = female, y = perc, fill = biden_cat) +
  geom_bar(data = warm, stat = "identity", width = 0.5) +
  geom_bar(data = cold, stat = "identity", width = 0.5) +
  geom_hline(yintercept = 0, color = "ivory3") +
  scale_fill_manual(name = "", values = c("warmest" = "indianred4", "warmer" = "indianred1",
                                                       "colder" = "ivory3", "coldest" = "ivory4")) +
  scale_y_continuous(breaks = NULL) +
  labs(x = "", y = "Feeling Thermometer", title = "Attitudes toward Joe Biden by gender, age, and party") +
  theme(legend.position = "bottom", legend.direction = "horizontal") +
  facet_grid(~ party)

# Export
png(filename = "submissions/Liu_Guangyu/assignment1/bar_thermo.png")
plot(bar_thermo)
dev.off()
