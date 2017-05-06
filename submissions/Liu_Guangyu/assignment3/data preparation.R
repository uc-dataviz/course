#---
# May 3, 2017
# Assignment 3 -- Clean data
#---

library(tidyr)
library(tidyverse)
library(rworldmap)
library(gapminder)
library(readxl)
library(ggplot2)
library(scales)
library(plotly)

setwd("submissions/Liu_Guangyu/assignment3")

# Data import and transformation
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

########################################
# Draw world map
mapDevice()
gdp_eduGap %>% 
  filter(year == 2009) %>% 
  rename(continent1 = continent) %>% 
  joinCountryData2Map(joinCode = "NAME", nameJoinColumn = "country") %>% 
  mapCountryData(nameColumnToPlot = "continent1",
                 numCats = 5,
                 catMethod = "categorical",
                 colourPalette = c("royalblue1", "green1", "firebrick1", "yellow1", "orchid1"),
                 addLegend = FALSE,
                 borderCol = FALSE,
                 missingCountryCol = "ivory2",
                 mapTitle = "") 
pdf(file = "mapLegend.png")
plot(mapLegend)
dev.off()
gdp_eduGap <- read_csv("gdp_eduGap.csv")

testData <- filter(gdp_eduGap,
                   year == 1990)

p <- ggplot(testData, 
       aes(x = gdp_per_capita, y = eduyrs_fofm)) +
  geom_point(aes(size = population, text = country, fill = continent), color = "grey17", shape = 21) +
#  geom_point(aes(size = population, text = country), color = "black", shape = 1) +
  geom_hline(yintercept = 100, color = "red", linetype = 2, size = 0.5) +
  scale_size_continuous(range = c(0,30)) +
  scale_x_continuous(name = "GDP  ($)", 
                     trans = log2_trans(),
                     breaks = trans_breaks("log2", n = 9, function(x) 250*(2^x))(c(1,300)),
                     position = "right") +
  scale_y_continuous(name = "Gender ratio of years in school (female/male)  (%)") +
  scale_fill_manual(name = "", 
                    values = c("Asia" = "firebrick1", 
                               "Europe" = "yellow1", 
                               "Americas" = "green1",
                               "Africa" = "royalblue1",
                               "Oceania" = "orchid1")) +
  coord_cartesian(
    xlim = c(min(gdp_eduGap$gdp_per_capita,na.rm = TRUE), 
             max(gdp_eduGap$gdp_per_capita, na.rm = TRUE)),
    ylim = c(0, max(gdp_eduGap$eduyrs_fofm))
    ) +
  theme(legend.position = "none")

ggplotly(p, tooltip = "text")
