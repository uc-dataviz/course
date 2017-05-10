library(shiny)
library(tidyverse)
library(shinythemes)
library(plotly)
library(DT)

NBA <- read_csv("NBA.csv")

ui <- fluidPage(
  theme = shinytheme("darkly"),
  titlePanel("2014-2015 NBA Shots"), br(),
  tabsetPanel(
  tabPanel("By Player", icon = icon("male"),
    sidebarLayout(
      sidebarPanel(
        textInput(inputId = "shooter_input", label = "Player's full name, sans caps", value = "jimmy butler"),
        sliderInput(inputId = "defender_distance", label = "Distance from closest defender", min = 0, max = 53.2,
                    value = c(0, 8.5), post = "ft."),
        sliderInput(inputId = "shot_clock", label = "Shot Clock", min = 0, max = 24,
                      value = c(5, 17), post = "sec."),
        checkboxInput(inputId = "dates_cal_input", label = "Select dates"),
        conditionalPanel(
          condition = "input.dates_cal_input == true",
          dateRangeInput(inputId = "cal_input", label = "Date Range",
                         min = "2014-10-29", max = "2015-03-04", 
                         start = "2014-10-29", end = "2015-03-04")
        ),
        tags$hr(),
        textOutput("plotly_instructions"),
        tags$hr(),
        tags$head(tags$style("#plotly_instructions{color: grey;
                                 font-size: 13px;
                                 font-style: italic;
                            }"))
        
      ),
      mainPanel(tabsetPanel(
        tabPanel("Time", icon = icon("hourglass-half"),
                 plotlyOutput("dist_points_plot")),
        tabPanel("Quarter", icon = icon("bar-chart-o"),
                 plotlyOutput("quarter_plot")),
        tabPanel("Distance",icon = icon("send"),
                 plotlyOutput("shot_dist_plot")),
        tabPanel("Shot", icon = icon("flash"),
                 plotlyOutput("shot_type_plot")),
        tabPanel("Raw Data", icon = icon("table"),
                 DT::dataTableOutput("player_results"))))
    )
  ),
  tabPanel("By Team", icon = icon("dribbble"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "shooter_team_input", label = "Shooter's Team", 
                  choices = c("SAS", "GSW", "HOU", "LAC", "UTA", "CHA", "MIN",
                              "OKC", "LAL", "ATL", "WAS", "SAC", "NOP", "TOR",
                              "DAL", "ORL", "CLE", "IND", "BOS", "PHX", "MEM",
                              "POR", "DEN", "MIA", "PHI", "MIL", "NYK", "DET",
                              "CHI", "BKN"),
                  selected = "CHI"),
      selectInput(inputId = "opposing_team_input", label = "Opposing Team", 
                  choices = c("SAS", "GSW", "HOU", "LAC", "UTA", "CHA", "MIN",
                              "OKC", "LAL", "ATL", "WAS", "SAC", "NOP", "TOR",
                              "DAL", "ORL", "CLE", "IND", "BOS", "PHX", "MEM",
                              "POR", "DEN", "MIA", "PHI", "MIL", "NYK", "DET",
                              "CHI", "BKN"),
                  selected = "MIN")
    ),
    mainPanel(tabsetPanel(
      tabPanel("Attempts", icon = icon("line-chart"),
               plotlyOutput("made_missed_plot")),
      tabPanel("Distance", icon = icon("send"),
               plotlyOutput("dist_plot")),
      tabPanel("Touch Time", icon = icon("hourglass-half"),
               plotlyOutput("player_touch_plot")),
      tabPanel("Raw Data", icon = icon("table"),
               DT::dataTableOutput("dist_results"))))
  )
  )
)
)
