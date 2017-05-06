library(shiny)
library(plotly)
library(tidyverse)
library(rworldmap)

gdp_eduGap <- read.csv("gdp_eduGap.csv") %>% 
  arrange(country)

ui <- fluidPage(titlePanel("How does education gender gap changes"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(inputId = "inputCountry",
                                label = "Select Countries",
                                choices = gdp_eduGap$country,
                                multiple = TRUE),
                    sliderInput(inputId = "inputYear",
                                label = "Year",
                                min = min(gdp_eduGap$year, na.rm = TRUE),
                                max = max(gdp_eduGap$year, na.rm = TRUE),
                                animate = animationOptions(interval = 500, 
                                                           loop = TRUE), 
                                sep = "",
                                step = 1,
                                value = 1970),
                    plotOutput("continentMap", height = 200)
                    ),
                  mainPanel(
                    plotlyOutput("bubbleChart", height = 600, width = "auto")
                  ))
                )
                
