# Down load files

library(curl)
library(geonames)
library(tidyverse)
library(rvest)
library(stringr)
library(jsonlite)
library(httr)


# Getting key for geonames.
key <- getOption("geonamesUsername")

# Getting dataset with contry information from geonames.
countryInfo <- GNcountryInfo()
write_csv(countryInfo, "./data/GNcountryInfo.csv")




