library(tidyverse)
library(gapminder)
library(readxl)
library(plotrix)
library(plotly)
library(shiny)

import_gapminder <- function(filename, inc_name = NA){
  # import file
  indicator <- read_excel(filename)
  
  # rename first column to country, store indicator name for later
  inc_fullname <- names(indicator)[[1]]
  names(indicator)[[1]] <- "country"
  
  # tidy data frame and add indicator name as variable
  indicator <- indicator %>%
    gather(year, value, -1, convert = TRUE) %>%
    mutate(value = as.numeric(value),
           variable = ifelse(!is.na(inc_name), inc_name, inc_fullname)) %>%
    select(country, year, variable, value)
}  


arms_import <- import_gapminder("../dataviz/submissions/Pennington_Brian/Assignment 3/Arms imports.xlsx", inc_name = "arms import")
arms_export <- import_gapminder("../dataviz/submissions/Pennington_Brian/Assignment 3/Arms exports.xlsx", inc_name = "arms export") 
student <- import_gapminder("../dataviz/submissions/Pennington_Brian/Assignment 3/expenditure primary.xlsx", inc_name = "%GDP on Students") 
army_perc <- import_gapminder("../dataviz/submissions/Pennington_Brian/Assignment 3/indicator army_percent.xlsx",inc_name = "%Army of Workforce")
army_total <-import_gapminder("../dataviz/submissions/Pennington_Brian/Assignment 3/indicator army_total.xlsx", inc_name = "Army Total") 
ed_aid <- import_gapminder("../dataviz/submissions/Pennington_Brian/Assignment 3/indicator_education aid (% of total aid).xlsx", inc_name = "Ed Aid") 
GDP <- read.csv("../dataviz/submissions/Pennington_Brian/Assignment 3/indicator gapminder gdp_per_capita_ppp.csv")

GDP <- GDP %>%
  gather(`X1800`:`X2015`, key= "year", value= "GDP")

as.character(GDP$year)
year <- stringr::str_sub(GDP$year, 2, 5) %>%
  as.integer() %>%
  as.data.frame() 

GDP$year <- NULL

GDP <- bind_cols(GDP, year)
as.data.frame(GDP)

colnames(GDP) <- c("country", "GDP", "year")

data <- bind_rows(arms_import, arms_export, student, army_perc, army_total, ed_aid)

data <- spread(data, key= variable, value= value)

se <- function(x) sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))

data %>%
  mutate(import_1000 = log(`arms import`)) %>%
  mutate(export_1000 = log(`arms export`)) %>%
  ggplot(aes(x = import_1000, y= export_1000)) +
  geom_point()

data %>%
  group_by(year) %>%
  mutate(avg_imp = mean(`arms import`, na.rm = TRUE)) %>%
  mutate(imp_high = mean(`arms import`, na.rm = TRUE) + 1.96*std.error(`arms import`, na.rm=TRUE)) %>%
  mutate(imp_low = mean(`arms import`, na.rm = TRUE) - 1.96*std.error(`arms import`, na.rm=TRUE)) %>%
  mutate(avg_exp = mean(`arms export`, na.rm = TRUE)) %>%
  mutate(exp_high = mean(`arms export`, na.rm = TRUE) + 1.96*std.error(`arms export`, na.rm=TRUE)) %>%
  mutate(exp_low = mean(`arms export`, na.rm = TRUE) - 1.96*std.error(`arms export`, na.rm=TRUE)) %>%
  mutate(impexp = `arms export`/`arms import`) %>%
  mutate(mean_ratio = mean(impexp, na.rm = TRUE)) %>%
  ggplot(aes(x = year)) +
  geom_line(aes(y = avg_imp, color = "import")) +
  geom_line(aes(y = avg_exp, color = "export")) +
  geom_ribbon(aes(ymin = imp_low, ymax= imp_high), alpha = .1, fill = "blue") +
  geom_ribbon(aes(ymin = exp_low, ymax = exp_high), alpha = .1, fill = "red") +
  geom_smooth(aes(y = avg_imp), color = "black") +
  geom_smooth(aes(y = avg_exp), color = "black")

d <- ggplotly(p)
d

  
data %>%
  group_by(year) %>%
  mutate(impexp = mean(`arms export`,na.rm = TRUE)/mean(`arms import`, na.rm = TRUE)) %>%
  mutate(mean_ratio = mean(impexp, na.rm = TRUE)) %>%
  ggplot(aes(x = year)) +
  geom_line(aes(y= mean_ratio, color = "export-import ratio")) +
  geom_smooth(aes(y =mean_ratio))

  
  
  
  ui <- fluidPage(titlePanel("The Global Arms Market: Import and Exports of Arms over the Half Century"),
                  sidebarLayout(
                    sidebarPanel(
                      sliderInput(
                        "yearInput",
                        "Year",
                        min = 1955,
                        max = 2010,
                        value = c(1955, 2010)
                      ),
                      uiOutput("armInput"),
                      selectInput(
                        "compareInput",
                        "Compare: Make sure to select only a few countries to compare at a time",
                        choices = c("Yes", "No"),
                        selected = "No",
                        multiple = FALSE
                      )),
                    mainPanel(plotOutput("Average"),
                              plotOutput("Ratio")
                  )))
  
  
server <- function(input, output) {
    
    output$armInput <- renderUI({
      selectizeInput(
        "countryInput",
        "Country",
        choices = data$country,
        multiple = TRUE
      )
    })
    
    output$Average <- renderPlot({
      
      if(!is.null(input$countryInput)){
        data <- filter(data, country %in% input$countryInput)
      }
      
      data <- data %>%
        group_by(year) %>%
        mutate(avg_imp = mean(`arms import`, na.rm = TRUE)) %>%
        mutate(imp_high = mean(`arms import`, na.rm = TRUE) + 1.96*se(`arms import`)) %>%
        mutate(imp_low = mean(`arms import`, na.rm = TRUE) - 1.96*se(`arms import`)) %>%
        mutate(avg_exp = mean(`arms export`, na.rm = TRUE)) %>%
        mutate(exp_high = mean(`arms export`, na.rm = TRUE) + 1.96*se(`arms export`)) %>%
        mutate(exp_low = mean(`arms export`, na.rm = TRUE) - 1.96*se(`arms export`)) %>%
        mutate(impexp = `arms export`/`arms import`) %>%
        mutate(mean_ratio = mean(impexp, na.rm = TRUE)) %>%
        filter(
          year >= input$yearInput[1],
          year <= input$yearInput[2])
      
      if(input$compareInput == "No"){
        ggplot(data, aes(x = year)) +
        geom_line(aes(y = avg_imp, color = "import")) +
        geom_line(aes(y = avg_exp, color = "export")) +
        geom_ribbon(aes(ymin = imp_low, ymax= imp_high), alpha = .1, fill = "blue") +
        geom_ribbon(aes(ymin = exp_low, ymax = exp_high), alpha = .1, fill = "red") +
        geom_smooth(aes(y = avg_imp), color = "black") +
        geom_smooth(aes(y = avg_exp), color = "black")
    } else{
      ggplot(data, aes(x = year)) +
        facet_wrap(~country) +
        geom_line(aes(y = `arms import`, color = "import")) +
        geom_line(aes(y = `arms export`, color = "export")) +
        geom_smooth(aes(y = `arms import`), color = "black") +
        geom_smooth(aes(y = `arms export`), color = "black")
    }
  })
    
    
    output$Ratio <- renderPlot({
      if(!is.null(input$countryInput)){
        data <- filter(data, country %in% input$countryInput)
      }
      
      data <- data %>%
        group_by(year) %>%
        mutate(impexp = mean(`arms export`,na.rm = TRUE)/mean(`arms import`, na.rm = TRUE)) %>%
        mutate(indavg = `arms export`/`arms import`) %>%
        mutate(mean_ratio = mean(impexp, na.rm = TRUE)) %>%
        filter(
          year >= input$yearInput[1],
          year <= input$yearInput[2])
      
      if(input$compareInput == "No"){
        ggplot(data, aes(x = year)) +
          geom_line(aes(y= mean_ratio, color = "export-import ratio")) +
          geom_smooth(aes(y =mean_ratio))
      } else {
        ggplot(data, aes(x = year)) +
          geom_line(aes(y= indavg, color = "export-import ratio")) +
          geom_smooth(aes(y =indavg)) +
          facet_wrap(~country)
      }
  })
}


shinyApp(ui = ui, server = server)
