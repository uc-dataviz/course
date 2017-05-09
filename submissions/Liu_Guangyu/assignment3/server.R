library(shiny)
library(tidyverse)
library(stringr)
library(dplyr)
library(plotly)
library(scales)

server <- function(input, output){
  gdp_eduGap <- read.csv("gdp_eduGap.csv") %>% 
    arrange(country)
  mapLegend <- read.csv("mapLegend.csv")
  
  output$bubbleChart <- renderPlotly({
    filterData <- filter(gdp_eduGap, year == input$inputYear)
    if (!is.null(input$inputCountry)){
      filterData <- filter(filterData, country %in% input$inputCountry)
    }
    p <- ggplot(filterData, 
              aes(x = gdp_per_capita, y = eduyrs_fofm, size = population)) +
      geom_point(aes(text = str_c(paste("Country:", country), 
                                  paste("Population: ", population),
                                  paste("GDP: ", gdp_per_capita),
                                  paste("Edu female % male: ", round(eduyrs_fofm, 2), "%"),
                                  sep = '\n'), 
                     fill = continent), 
                 color = "grey17", shape = 21) +
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
    p2 <- ggplot(mapLegend, aes(x = long, y = lat, group = group, fill = continent)) +
      geom_polygon(color = "grey") +
      scale_fill_manual(values = c("royalblue1", "green1", "firebrick1", "yellow1", "orchid1")) +
      theme(legend.position = "none", 
            panel.background = NULL, 
            axis.text = element_blank(), 
            axis.title = element_blank(),
            axis.ticks = element_blank()) +
      coord_map()

#    ggplot(mapLegend, aes(x = long, y = lat, group = group, fill = continent)) +
#      geom_polygon(color = "grey") +
#      scale_fill_manual(name = "",
#                        values = c("Africa" = "royalblue1", 
#                                   "Americas" = "green1", 
#                                   "Asia" = "firebrick1", 
#                                   "Europe" = "yellow1", 
#                                   "Oceania" = "orchid1")) +
#      theme(legend.position = "none", 
#            panel.background = NULL, 
#            axis.text = element_blank(), 
#            axis.title = element_blank(),
#            axis.ticks = element_blank()) +
#      coord_map()
    
    if (!is.null(input$inputCountry)){
      filterData <- filter(mapLegend, country %in% input$inputCountry)
      p2 <- p2 +
        geom_polygon(data = filterData, fill = ifelse(filterData$region == "Asia", "red", "white"))
    }
    p2
})
}
