library(shiny)
library(plotly)
library(tidyverse)
library(maps)
library(rworldmap)
library(stringr)

gdp_eduGap <- read.csv("gdp_eduGap.csv") %>% 
  arrange(country)

ui <- navbarPage("Educational Gender Gap and GDP per Capita",
          tabPanel("Graph",
                sidebarLayout(
                  sidebarPanel(
                    selectizeInput(inputId = "inputCountry",
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
                    # Auto play
                    tags$script("$(document).ready(function(){
                        setTimeout(function() {$('.slider-animate-button').click()},500);
                                });"),   
                    plotOutput("continentMap", height = 200)
                    ),
                  mainPanel(
                    plotlyOutput("bubbleChart", height = "auto", width = "auto")
                  ))
                ),
          tabPanel("A Narrative"),
          tabPanel("Explanation")
)
