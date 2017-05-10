#---
# May 3, 2017
# Assignment 3 -- Clean data
#---

library(tidyr)
library(tidyverse)
library(rworldmap)
library(gapminder)
library(stringr)
library(readxl)
library(ggplot2)
library(scales)
library(plotly)

setwd("submissions/Liu_Guangyu/assignment3")

# Prepare data for bubble chart
## Data import and transformation
import_gapminder <- function(filename, col_name){
  indicator <- read_excel(filename)
  names(indicator)[[1]] <- "country"
  indicator <- indicator[!is.na(names(indicator))] %>% # Drop all NAs columns
    gather(-country, key = "year", value = "value", convert = TRUE, na.rm = TRUE) 
  names(indicator)[[3]] <- col_name
  indicator
}

edu_perc <- import_gapminder("data/Years in school, women 25 to 34 as percent of men.xlsx", "eduyrs_fofm")
pop <- import_gapminder("data/indicator gapminder population.xlsx", "population") %>% 
  filter(year >= 1970 & year <= 2009)

# Import gdp data used for Gapminder's bubble chart
geo <- read.csv("data/geo.csv")
gdp <- read.csv("data/gdp_geo_time.csv")

# Get continent information from gapminder
continent <- select(gapminder, country, continent) %>% 
  distinct()

# Select gdp data from 1970 to 2009, add country name and continent according to `geo`
gdp <- filter(gdp, time >= 1970 & time <= 2009) %>% 
  mutate(year = as.numeric(time)) %>%  
  select(-time) %>% 
  spread(key = year, value = gdp_per_capita_cppp) %>% 
  inner_join(geo) %>% 
  rename(country = name) %>% 
  inner_join(continent) %>% 
  gather(-country, -geo, -continent, key = "year", value = "gdp_per_capita") %>% 
  mutate(year = as.numeric(year)) %>% 
  select(-geo) %>% 
  inner_join(pop)

# Add education gender gap
gdp_eduGap <- inner_join(gdp, edu_perc) 

write.csv(gdp_eduGap, file = "gdp_eduGap.csv")

# Prepare data frame for map legend
## Rename unmatched country names
mapLegend <- map_data("world") %>% 
  mutate(region = ifelse(region == "Democratic Republic of the Congo", "Congo, Dem. Rep.",
                         ifelse(region == "Republic of Congo", "Congo, Rep.",
                                ifelse(region == "Ivory Coast", "Cote d'Ivoire",
                                       ifelse(region == "South Korea", "Korea, Dem. Rep",
                                              ifelse(region == "North Korea", "Korea, Rep.",
                                                     ifelse(region == "Slovakia", "Slovak Republic",
                                                            ifelse(region == "Trinidad", "Trinidad and Tobago",
                                                                   ifelse(region == "UK", "United Kingdom",
                                                                          ifelse(region == "USA", "United States",
                                                                                 ifelse(region == "Yemen", "Yemen, Rep.", region))))))))))) %>% 
  rename(country = region)  %>% 
  group_by(country) %>% 
  left_join(continent) %>% 
  ungroup() 

write.csv(mapLegend, file = "mapLegend.csv")
