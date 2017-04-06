#---
# title: Assignment 1
# author: Guangyu Liu
# due date: April 10, 2017
#---

library(tidyr)
library(tidyverse)

# Read data
Biden <- read.csv(file = "Liu_Guangyu/assignment1/biden.csv")

# Recode categorical variables
attach(Biden)

# Recode female
Biden$female <- factor(Biden$female, levels = c(0, 1), labels = c("male", "female"))

# Recode party
Biden$party[dem == 1] <- "dem"
Biden$party[rep == 1] <- "rep"
Biden$party[dem == 0 & rep == 0] <- "other"
Biden$party <- factor(Biden$party, levels = c("dem", "rep", "other"))

# Recode educ
Biden$educ_cat[educ < 12] <- "less than HS"
Biden$educ_cat[educ == 12] <- "HS degree"
Biden$educ_cat[educ > 12 & educ < 16] <- "some college"
Biden$educ_cat[educ == 16] <- "college degree"
Biden$educ_cat[educ > 16] <- "graduate"
Biden$educ_cat <- ordered(Biden$educ_cat, 
                         levels = c("less than HS", "HS degree", "some college",
                                    "college degree", "graduate"))

# Recode biden
Biden$biden_cat[biden <= quantile(biden)[2]] <- "coldest" 
Biden$biden_cat[biden > quantile(biden)[2] & biden <= quantile(biden)[3]] <- "colder"
Biden$biden_cat[biden > quantile(biden)[3] & biden <= quantile(biden)[4]] <- "warmer"
Biden$biden_cat[biden > quantile(biden)[4]] <- "warmest" 
Biden$biden_cat <- factor(Biden$biden_cat, 
                          levels = c("coldest", "colder", "warmer", "warmest"))
detach(Biden)

# Percentage of attitude within each education category
biden_perc <- Biden %>%
  group_by(female, party, educ_cat, biden_cat) %>% 
  summarize(freq = n()) %>% 
  mutate(perc = round(freq/sum(freq)*100, 2))

# Split biden_perc into two groups: cold and warm
cold <- filter(biden_perc, biden_cat == "coldest" | biden_cat == "colder")
warm <- filter(biden_perc, biden_cat == "warmer" | biden_cat == "warmest")

# Negate the percentage of cold attitude, reverse order
cold$perc = -cold$perc
warm$biden_cat <- ordered(warm$biden_cat, levels = rev(levels(warm$biden_cat)))
# cold$biden_cat <- ordered(cold$biden_cat, levels = rev(levels(cold$biden_cat)))

# Explore viz
ggplot() +
  aes(x = female, y = perc, fill = biden_cat) +
  geom_bar(data = cold, stat = "identity") +
  geom_bar(data = warm, stat = "identity") +
  geom_hline(yintercept = 0, color = "white") +
  scale_fill_brewer(palette = "Reds") +
  scale_y_continuous(name = "Biden") +
  theme_classic() +
  facet_grid(party ~ educ_cat)
