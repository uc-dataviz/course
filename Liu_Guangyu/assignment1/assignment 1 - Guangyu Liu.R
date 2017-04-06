#---
# title: Assignment 1
# author: Guangyu Liu
# due date: April 10, 2017
#---

library(tidyr)
library(tidyverse)
library(HH)

# Read data
Biden <- read.csv(file = "Liu_Guangyu/assignment1/biden.csv")

# Convert female, dem, rep to factors
Biden$female <- factor(Biden$female)
Biden$dem <- factor(Biden$dem)
Biden$rep <- factor(Biden$rep)

attach(Biden)

# Recode party
Biden$party[dem == "1"] <- "dem"
Biden$party[rep == "1"] <- "rep"
Biden$party[dem == "0" & rep == "0"] <- "other"

# Recode educ into a categorical variable
Biden$educ_cat[educ < 12] <- "less than HS"
Biden$educ_cat[educ == 12] <- "HS degree"
Biden$educ_cat[educ > 12 & educ < 16] <- "some college"
Biden$educ_cat[educ == 16] <- "college degree"
Biden$educ_cat[educ > 16] <- "graduate"

# Recode biden into four categories -- coldest, colder, warmer, and warmest
Biden$biden_cat[biden <= quantile(biden)[2]] <- 1 # first quartile
Biden$biden_cat[biden > quantile(biden)[2] & biden <= quantile(biden)[3]] <- 2
Biden$biden_cat[biden > quantile(biden)[3] & biden <= quantile(biden)[4]] <- 3
Biden$biden_cat[biden > quantile(biden)[4]] <- 4 # third quartile
Biden$biden_cat <- ordered(Biden$biden_cat, 
                           levels = c(1, 2, 3, 4),
                           labels = c("coldest", "colder", "warmer", "warmest"))

detach(Biden)

# Convert those variables into factors
Biden$party <- factor(Biden$party)
Biden$educ_cat <- factor(Biden$educ_cat)


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
cold$biden_cat <- ordered(cold$biden_cat, levels = rev(levels(cold$biden_cat)))

# Explore viz
ggplot() +
  aes(x = female, y = perc, fill = biden_cat) +
  geom_bar(data = cold, stat = "identity") +
  geom_bar(data = warm, stat = "identity") +
  geom_hline(yintercept = 0, color = "white") +
  scale_y_continuous(name = "Biden") +
  facet_grid(~educ_cat)

ggplot() +
  geom_bar(filter(Biden, biden_cen > 0), mapping = aes(x = party, y = biden_cen, fill = educ_cat), 
           stat = "bin")+
  geom_bar(filter(Biden, biden_cen <= 0), mapping = aes(x = party, y = biden_cen, fill = educ_cat), 
           stat = "bin")

ggplot(Biden) +
  geom_bar(aes(x = educ_cat, y = biden_cen, fill = biden_cat), stat = "identity")
