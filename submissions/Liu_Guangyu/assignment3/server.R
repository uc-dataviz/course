library(shiny)
library(tidyverse)
library(dplyr)
library(plotly)
library(scales)

server <- function(input, output){
  output$bubbleChart <- renderPlotly({
    filterData <- filter(gdp_eduGap, 
#             ifelse(is.na(input$inputCountry), country, country %in% input$inputCountry),
             year == input$inputYear)
  
    p <- ggplot(filterData, 
                aes(x = gdp_per_capita, y = eduyrs_fofm)) +
      geom_point(aes(size = population, text = country, fill = continent), color = "grey17", shape = 21) +
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
  })
  
  output$continentMap <- renderPlot({
    gdp_eduGap %>% 
      filter(year == 2009) %>% 
      rename(continent1 = continent) %>% 
      joinCountryData2Map(joinCode = "NAME", nameJoinColumn = "country") %>% 
      mapCountryData(nameColumnToPlot = "continent1",
                     numCats = 5,
                     mapRegion = "world",
                     catMethod = "categorical",
                     colourPalette = c("royalblue1", "green1", "firebrick1", "yellow1", "orchid1"),
                     addLegend = FALSE,
                     borderCol = FALSE,
                     missingCountryCol = "ivory2",
                     mapTitle = "")
  })
}
