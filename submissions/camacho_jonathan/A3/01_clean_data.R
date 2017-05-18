# Libraries necessary for the script to run. 
library(tidyverse)
library(countrycode)
library(gapminder)

# Reading the data to a dataframe. 
GNcountryInfo <- as_tibble(read.csv(file = "./data/GNcountryInfo.csv",
                                    stringsAsFactors = FALSE))

# Transformations. 
## Creating the variable contryCode (iso2c format) from the column country. 
gapminder <- gapminder %>% 
    mutate(countryCode = countrycode(gapminder$country, 
                                     "country.name", "iso2c"))

# Joining datasets by countryCode.
tidy_countries_dataset <- left_join(gapminder, GNcountryInfo, "countryCode")

# Writing tidy_data to a cvs file. 
write_csv(tidy_countries_dataset, "./data/tidy_countries_dataset.csv")
