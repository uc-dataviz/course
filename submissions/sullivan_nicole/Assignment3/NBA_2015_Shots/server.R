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
  
  output$background <- renderText ({
    "Data used in this Shiny web app is from the NBA 2014-2015 Season Shot Logs.  The app is meant for exploration of player's likelihood of making or missing a shot, depending on the shot clock, distance from the hoop, distance from the nearest defender,
  the quarter, whether they were away or home - even which of their teammates were playing that game (see the 'By Team' tab).  One can see the obvious - that the farther players are from the hoop, the less likely they are to make a shot - and the not-so-obvious - that even players 
    lauded for their ability outside the paint (e.g. the Splash Brothers) missed threes more often than they made them.  Suggestions for exploration of the data:  look a player's or team's performance when playing very high performing or low performing teams in comparison (the Bulls,
    for example, tend to perform beyond expectations when facing especially challenging teams - such as Golden State or the Cavs - but tend to underperform when pitted against much lower seeded teams - such as the Suns or the Lakers).   Or evaluate intra-player performance in a specific game - such as the Championship Finals; just check the 'Select Dates'
box in the 'By Player' tab."
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
      labs(title = "Pre-Shot Touch Time & Distance From Hoop",
           x = "Touch Time (in sec.)",
           y = "Shot Distance (in ft.)",
           color = "Points") +
      scale_x_continuous(breaks = seq(0, 25, by = 5)) +
      theme(plot.title = element_text(hjust = 0.5, color = "white", family = "Helvetica", size = 10),
            plot.background = element_rect(fill = "gray20", color = "gray20"),
            axis.text = element_text(color = "white", family = "Helvetica", size = 8),
            axis.title = element_text(color = "white", family = "Helvetica", size = 9),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white", family = "Helvetica", size = 9),
            legend.title = element_text(color = "white", family = "Helvetica", size = 9),
            legend.position = "bottom",
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
      geom_bar(position = "dodge", width = .2) +
      scale_fill_discrete(breaks = c("made","missed"), 
                          labels = c("Made", "Missed")) +
      labs(title = "Shot Accuracy By Quarter",
           x = "Shot Outcome",
           y = "Count") +
      scale_x_discrete(limits = c("A", "H"), labels = c("Away", "Home")) +
      facet_wrap(~ Quarter) +
      theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
            axis.text = element_text(color = "white", family = "Helvetica", size = 8),
            axis.title = element_text(color = "white", family = "Helvetica", size = 9),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white", family = "Helvetica", size = 9),
            legend.title = element_blank(),
            legend.position = "bottom",
            plot.title = element_text(hjust = 0.5, color = "white", family = "Helvetica", size = 10),
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
      geom_boxplot(aes(color = `Shot Result`), alpha = 0.5) +
      labs(title = "Average Distance for Shot Type",
           y = "Shot Distance (in ft.)") +
      facet_wrap(~ `Away/Home`) +
      theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
            axis.text = element_text(color = "white", family = "Helvetica", size = 8),
            axis.title = element_text(color = "white", family = "Helvetica", size = 9),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white", family = "Helvetica", size = 9),
            legend.title = element_blank(),
            legend.position = "bottom",
            plot.title = element_text(hjust = 0.5, color = "white", family = "Helvetica", size = 10),
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
      geom_bar(position = "dodge", width = 0.3) +
      scale_fill_discrete(breaks = c("made","missed"), 
                          labels = c("Made", "Missed")) +
      scale_x_discrete(limits = c("A", "H"), labels = c("Away", "Home")) +
      labs(title = "Shot Accuracy By Type",
           x = "Shot Outcome",
           y = "Count") +
      facet_wrap(~ `Shot Type`) +
      theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
            axis.text = element_text(color = "white", family = "Helvetica", size = 8),
            axis.title = element_text(color = "white", family = "Helvetica", size = 9),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white", family = "Helvetica", size = 9),
            legend.title = element_blank(),
            legend.position = "bottom",
            plot.title = element_text(hjust = 0.5, color = "white", family = "Helvetica", size = 10),
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
    geom_point(alpha = 0.7, size = 1) +
    facet_wrap(~ Shooter) +
    labs(title = "Defensive Pressure and Shot Distance",
         x = "Distance to Closest Defender (in ft.)",
         y = "Shot Distance (in ft.)") +
    theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
          axis.text = element_text(color = "white", family = "Helvetica", size = 8),
          axis.title = element_text(color = "white", family = "Helvetica", size = 9),
          legend.background = element_rect(fill = "gray20"),
          legend.key = element_rect(color = "gray20"),
          legend.text = element_text(color = "white", family = "Helvetica", size = 9),
          legend.title = element_blank(),
          legend.position = "bottom",
          plot.title = element_text(hjust = 0.5, color = "white", family = "Helvetica", size = 10),
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
      theme(plot.title = element_text(hjust = 0.5, color = "white", family = "Helvetica", size = 10),
            legend.title = element_blank(),
            plot.background = element_rect(fill = "gray20", color = "gray20"),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white"),
            axis.text = element_text(color = "white", family = "Helvetica", size = 8),
            axis.title = element_text(color = "white", family = "Helvetica", size = 9),
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
      geom_boxplot(aes(color = `Shot Result`), alpha = 0.5) +
      coord_flip() +
      labs(title = "Player's Average Pre-Shot Touch Time",
           x = "Shooter",
           y = "Touch Time (in sec.)") +
      theme(plot.background = element_rect(fill = "gray20", color = "gray20"),
            legend.background = element_rect(fill = "gray20"),
            legend.key = element_rect(color = "gray20"),
            legend.text = element_text(color = "white", family = "Helvetica", size = 9),
            legend.title = element_blank(),
            axis.text = element_text(color = "white", family = "Helvetica", size = 8),
            axis.title = element_text(color = "white", family = "Helvetica", size = 9),
            plot.title = element_text(hjust = 0.5, color = "white", family = "Helvetica", size = 10),
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
