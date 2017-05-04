#---
# May 3, 2017
# Assignment 3 -- Clean data
#---

library(tidyr)
library(tidyverse)
library(gapminder)
library(readxl)

setwd("submissions/Liu_Guangyu/assignment3")

# Data import and transformation
import_gapminder <- function(filename, col_name){
  indicator <- read_excel(filename)
  names(indicator)[[1]] <- "country"
  indicator <- indicator %>% 
    gather(key = year, value = value, -country,convert = TRUE) 
  names(indicator)[[3]] <- col_name
  indicator
}

edu_perc <- import_gapminder("data/Years in school, women 25 to 34 as percent of men.xlsx", "eduyrs_fofm")

# Import gdp data used for Gapminder's bubble chart
geo <- read.csv("data/geo.csv")
gdp <- read.csv("data/gdp_geo_time.csv")

# Get continent information from gapminder
continent <- select(gapminder, country, continent) %>% 
  distinct()

# Select gdp data from 1970 to 2009, add country name and continent according to `geo`
gdp <- filter(gdp, time >= 1970 & time <= 2009) %>% 
  mutate(year = as.factor(time)) %>%  
  select(-time) %>% 
  spread(key = year, value = gdp_per_capita_cppp) %>% 
  inner_join(geo) %>% 
  rename(country = name) %>% 
  inner_join(continent) %>% 
  gather(-country, -geo, -continent, key = "year", value = "gdp_per_capita") %>% 
  select(-geo)
gdp$year <- as.numeric(gdp$year)

# Add education gender gap
gdp_eduGap <- inner_join(gdp, edu_perc)

write.csv(gdp_eduGap, file = "gdp_eduGap.csv")

########################################
ggplot(gap_gdp) +
  geom_point(aes(x = log(gdpPercap), y = eduyrs_fofm, color = continent), alpha = 0.1) +
  geom_smooth(aes(x = log(gdpPercap), y = eduyrs_fofm), se = FALSE)

# Draw world map
mapDevice()

gap_gdp %>% 
  filter(year == 2009) %>% 
  joinCountryData2Map(joinCode = "NAME", nameJoinColumn = "country") %>% 
  mapCountryData(nameColumnToPlot = "eduyrs_fofm") 

dev.off()
