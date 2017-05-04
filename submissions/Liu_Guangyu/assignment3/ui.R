library(shiny)
library(tidyverse)

gdp_eduGap <- read.csv("gdp_eduGap.csv")

ui <- fluidPage(titlePanel("How is education gender gap changes"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(inputId = "inputContinent",
                                label = "Choose a continent",
                                choices = gdp_eduGap$continent),
                    selectInput(inputId = "inputCountry",
                                label = "Choose a country",
                                choices = gdp_eduGap$country),
                    sliderInput(inputId = "inputYear",
                                label = "Year",
                                min = min(gdp_eduGap$year, na.rm = TRUE),
                                max = max(gdp_eduGap$year, na.rm = TRUE),
                                animate = animationOptions(interval = 1000, 
                                                           loop = TRUE), 
                                step = 1,
                                value = 1970)
                    ),
                  mainPanel("results go here"))
                )
                
