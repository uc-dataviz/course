library(shiny)
library(tidyverse)
library(DT)
library(shinythemes)
library(plotly)

NBA <- read_csv("NBA.csv")

server <- function(input, output) {
  
  output$plotly_instructions <- renderText ({
"Output graphs are interactive.  Remove elements by tapping on them in the legend,
    zoom, select or pan across data by clicking on plots, or
    view more detailed info on data by hovering over graphs." 
    })
  
  player <- reactive({
    
    if(input$dates_cal_input == TRUE) {
      
    NBA %>%
      filter(Shooter == input$shooter_input,
        `Distance to Closest Defender` >= input$defender_distance[1],
        `Distance to Closest Defender` <= input$defender_distance[2],
        `Shot Clock` >= input$shot_clock[1],
        `Shot Clock` <= input$shot_clock[2],
        Date >= input$cal_input[1],
        Date <= input$cal_input[2])
    }
    
    else {
     
       NBA %>%
        filter(Shooter == input$shooter_input,
               `Distance to Closest Defender` >= input$defender_distance[1],
               `Distance to Closest Defender` <= input$defender_distance[2],
               `Shot Clock` >= input$shot_clock[1],
               `Shot Clock` <= input$shot_clock[2])
      
    }
  
  })
  
  teams <- reactive({
    NBA %>%
      filter(`Shooter's Team` == input$shooter_team_input,
             `Opposing Team` == input$opposing_team_input)
  })

  output$dist_points_plot <- renderPlotly({
    if (is.null(player())) {
      return()
    }
    
   dist_points <- player()%>%
      mutate(`Points earned` = as.factor(`Points earned`)) %>%
      ggplot(aes(`Touch Time`, `Shot Distance`, color = `Points earned`)) +
      geom_point(alpha = 0.6, size = 1) +
      labs(title = "Pre-Shot Touch Time and Distance From Hoop",
           x = "Touch Time (in sec.)",
           y = "Shot Distance (in ft.)",
           color = "Points") +
      scale_x_continuous(breaks = seq(0, 25, by = 5)) +
      theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
            axis.text = element_text(color = "white"),
            axis.title = element_text(color = "white"),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white"),
            legend.title = element_text(color = "white"),
            legend.position = "bottom",
            plot.title = element_text(hjust = 0.5, color = "white"),
            panel.grid.major = element_line(color = "white", size = 0.8),
            panel.grid.major.x = element_blank(),
            panel.grid.minor.y = element_blank())
   
   ggplotly(dist_points)
   
  })
  
  output$quarter_plot <- renderPlotly({
    if (is.null(player())) {
      return()
    }
    
    quarter <- ggplot(player(), aes(`Away/Home`, fill = `Shot Result`)) +
      geom_bar(position = "dodge") +
      scale_fill_discrete(breaks = c("made","missed"), 
                          labels = c("Made", "Missed")) +
      labs(title = "Shot Accuracy By Quarter",
           x = "Shot Outcome",
           y = "Count") +
      scale_x_discrete(limits = c("A", "H"), labels = c("Away", "Home")) +
      facet_wrap(~ Quarter) +
      theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
            axis.text = element_text(color = "white"),
            axis.title = element_text(color = "white"),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white"),
            legend.title = element_blank(),
            legend.position = "bottom",
            plot.title = element_text(hjust = 0.5, color = "white"),
            panel.grid.major = element_line(color = "white", size = 0.8),
            panel.grid.major.x = element_blank(),
            panel.grid.minor.y = element_blank())
    
    ggplotly(quarter)
  })
  
  output$shot_dist_plot <- renderPlotly({
    if (is.null(player())) {
      return()
    }
    
    shot_dist <- player() %>%
      mutate(`Shot Type` = as.factor(`Shot Type`)) %>%
      ggplot(aes(`Shot Type`, `Shot Distance`, fill = `Shot Result`)) +
      geom_boxplot(color = `Shot Results`, alpha = 0.7) +
      labs(title = "Average Distance for Shot Type",
           y = "Shot Distance (in ft.)") +
      facet_wrap(~ `Away/Home`) +
      theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
            axis.text = element_text(color = "white"),
            axis.title = element_text(color = "white"),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white"),
            legend.title = element_blank(),
            legend.position = "bottom",
            plot.title = element_text(hjust = 0.5, color = "white"),
            panel.grid.major = element_line(color = "white", size = 0.8),
            panel.grid.major.x = element_blank(),
            panel.grid.minor.y = element_blank())
    
    ggplotly(shot_dist)
    
  })

  output$shot_type_plot <- renderPlotly({
    if (is.null(player())) {
      return()
    }
    
   type <- ggplot(player(), aes(`Away/Home`, fill = `Shot Result`)) +
      geom_bar(position = "dodge") +
      scale_fill_discrete(breaks = c("made","missed"), 
                          labels = c("Made", "Missed")) +
      scale_x_discrete(limits = c("A", "H"), labels = c("Away", "Home")) +
      labs(title = "Shot Accuracy By Type",
           x = "Shot Outcome",
           y = "Count") +
      facet_wrap(~ `Shot Type`) +
      theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
            axis.text = element_text(color = "white"),
            axis.title = element_text(color = "white"),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white"),
            legend.title = element_blank(),
            legend.position = "bottom",
            plot.title = element_text(hjust = 0.5, color = "white"),
            panel.grid.major = element_line(color = "white", size = 0.8),
            panel.grid.major.x = element_blank(),
            panel.grid.minor.y = element_blank())
   
   ggplotly(type)
   
  })
  
  output$player_results <- DT::renderDataTable(formatStyle(
    datatable(player()),
    columns = 1:20,
    color = "black",
    rownames = FALSE, 
    class = "hover"
  )
  )
  
  output$dist_plot <- renderPlotly({
    if (is.null(teams())) {
      return()
    }
    
  defend_dist <- teams() %>%
    mutate(`Points earned` = as.factor(`Points earned`)) %>%
    ggplot(aes(`Distance to Closest Defender`, `Shot Distance`, color = `Points earned`)) +
    geom_point() +
    facet_wrap(~ Shooter) +
    labs(title = "Defensive Pressure and Shot Distance",
         x = "Distance to Closest Defender (in ft.)",
         y = "Shot Distance (in ft.)") +
    theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
          axis.text = element_text(color = "white"),
          axis.title = element_text(color = "white"),
          legend.background = element_rect(fill = "gray20"),
          legend.key = element_rect(color = "gray20"),
          legend.text = element_text(color = "white"),
          legend.title = element_blank(),
          legend.position = "bottom",
          plot.title = element_text(hjust = 0.5, color = "white"),
          panel.grid.major = element_line(color = "white", size = 0.8),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.y = element_blank())
  
  ggplotly(defend_dist)
  
  })
  
  output$made_missed_plot <- renderPlotly({
    if (is.null(teams())) {
      return()
    }
    
    made_missed <- teams() %>%
      mutate(`Shot Type` = as.factor(`Shot Type`)) %>%
      ggplot(aes(`Shot Type`, fill = Shooter)) +
      geom_bar(position = "dodge") +
      labs(title = "Shot Attempts & Outcomes",
           x = "Shot Type",
           y = "Count") +
      facet_wrap(~ `Shot Result`) +
      theme(plot.title = element_text(hjust = 0.5, color = "white"),
            legend.title = element_blank(),
            plot.background = element_rect(fill = "gray20", color = "gray20"),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white"),
            axis.text = element_text(color = "white"),
            axis.title = element_text(color = "white"),
            panel.grid.major = element_line(color = "white", size = 0.8),
            panel.grid.major.x = element_blank(),
            panel.grid.minor.y = element_blank())
    
    ggplotly(made_missed)
    
  })
  
  output$player_touch_plot <- renderPlotly({
    if (is.null(teams())) {
      return()
    }
    
    player_touch <- teams() %>%
      ggplot(aes(Shooter, `Touch Time`, fill = `Shot Result`)) +
      geom_boxplot(color = "pink") +
      coord_flip() +
      labs(title = "Player's Average Pre-Shot Touch Time",
           x = "Shooter",
           y = "Touch Time (in sec.)") +
      theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white"),
            legend.title = element_blank(),
            axis.text = element_text(color = "white"),
            axis.title = element_text(color = "white"),
            plot.title = element_text(hjust = 0.5, color = "white"),
            panel.grid.major = element_line(color = "white", size = 0.8),
            panel.grid.major.x = element_blank(),
            panel.grid.minor.y = element_blank())
    
    ggplotly(player_touch)
    
  })
  
  output$dist_results <- DT::renderDataTable(formatStyle(
    datatable(teams()),
    columns = 1:20,
    color = "black",
    rownames = FALSE, 
    class = "hover"
  )
  
  )
}
