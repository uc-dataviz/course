library(shiny)
library(tidyverse)
library(stringr)
library(dplyr)
library(plotly)
library(scales)

server <- function(input, output){
  gdp_eduGap <- read.csv("gdp_eduGap.csv") %>% 
    arrange(year)
  mapLegend <- read.csv("mapLegend.csv")
  
  # World map legend, which does not change over time
  p2 <- ggplot(map_data("world"), aes(x = long, y = lat, group = group)) +
    geom_polygon(fill = "ivory1", color = "ivory3") +
    theme(legend.position = "none", 
          panel.background = NULL, 
          axis.text = element_blank(), 
          axis.title = element_blank(),
          axis.ticks = element_blank())
  
  # Calculate boundraries of the bubble chart
  min_x = min(gdp_eduGap$gdp_per_capita,na.rm = TRUE)
  max_x = max(gdp_eduGap$gdp_per_capita, na.rm = TRUE)
  min_y = 0
  max_y = max(gdp_eduGap$eduyrs_fofm, na.rm = TRUE)
  
  filterData <- gdp_eduGap
  p1 <- ggplot(data = filterData, aes(x = gdp_per_capita, y = eduyrs_fofm, size = population)) +
    geom_hline(yintercept = 100, color = "red", linetype = 2, size = 0.5) +
    scale_size_continuous(range = c(0,30)) +
    scale_x_continuous(name = "GDP per capita  ($)", 
                       trans = log2_trans(),
                       breaks = trans_breaks("log2", n = 9, function(x) 250*(2^x))(c(1,300)),
                       position = "right") +
    scale_y_continuous(name = "Gender ratio of years in school (female/male)  (%)") +
    coord_cartesian(
      xlim = c(min_x, max_x),
      ylim = c(min_y, max_y)
    ) +
    theme(legend.position = "none")
  
  output$bubbleChart <- renderPlotly({
    # Each year includes 131 countries. Use index rather than filter for optimization
    filterData <- slice(gdp_eduGap, ((input$inputYear - 1970) * 131 + 1):((input$inputYear - 1970 + 1) * 131))
    p1 <- p1 +
      geom_point(data = filterData, aes(text = str_c(paste("Country:", country), 
                                  paste("Population: ", population),
                                  paste("GDP: ", gdp_per_capita),
                                  paste("Edu female % male: ", round(eduyrs_fofm, 2), "%"),
                                  sep = '\n'),
                     fill = "ivory1"), color = "grey17", shape = 21)
    if (!is.null(input$inputCountry)){
      filterData <- filter(filterData, country %in% input$inputCountry)
    }
    p1 <- p1 +
      geom_point(data = filterData, aes(text = str_c(paste("Country:", country), 
                                                      paste("Population: ", population),
                                                      paste("GDP: ", gdp_per_capita),
                                                      paste("Edu female % male: ", round(eduyrs_fofm, 2), "%"),
                                                      sep = '\n'),
                                         fill = continent), color = "grey17", shape = 21) +
      scale_fill_manual(name = "", 
                        values = c("Asia" = "firebrick1", 
                                   "Europe" = "yellow1", 
                                   "Americas" = "green1",
                                   "Africa" = "royalblue1",
                                   "Oceania" = "orchid1",
                                   "NA" = "ivory1"))
    
    ggplotly(p1, tooltip = "text")
  })
  
  output$continentMap <- renderPlot({
    filterData <- mapLegend
    if (!is.null(input$inputCountry)){
      filterData <- filter(mapLegend, country %in% input$inputCountry)
    }
    p2 +
      geom_polygon(data = filterData, aes(fill = continent), color = NA) +
      scale_fill_manual(values = c("Asia" = "firebrick1", 
                                   "Europe" = "yellow1", 
                                   "Americas" = "green1",
                                   "Africa" = "royalblue1",
                                   "Oceania" = "orchid1"))
  })
}
