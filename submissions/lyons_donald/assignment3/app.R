library(shiny)
library(tidyverse)

d <- read_csv("a3d.csv")

#What I'm attempting to do here is allow people to choose a country and
#then have the option of choosing a year in which to see the distribution of
#wealth across the five groups. My initial plan was to use reactivity to make it
#such that selecting a country would then limit your choice of years to only those
#with data for that country. However, I have revised this to instead be selection
#of all years as I was getting a lot of errors otherwise.

ui <- fluidPage(titlePanel("Distribution of wealth by country and year"),
                em("This is an app designed to facilitate exploration of data regarding the
                     distribution of wealth around the world. Select a country and year to explore
                   the distribution of wealth for that country and year."),
                br(),
                strong("Note: visual plotting and year retrieval functions are currently limited. I recommend selecting Brazil to see the most complete possibility of this tool"),
                sidebarLayout(
                  sidebarPanel(
                    selectInput(
                      "countryInput",
                      "Country",
                      choices = c(d$country),
                    ),
                    selectInput(
                      "yearInput",
                      "Year",
                      choices = c (d$year)),
                    conditionalPanel(
                      condition = "input.countryInput == 'Albania'",
                      "Data available for 1997, 2002, 2005"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Algeria'",
                      "Data available for 1988, 1995"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Angola'",
                      "Data available for 2000"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Argentina'",
                      "Data available for 1986, 1992, 1996, 1998, 2002, 2005"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Armenia'",
                      "Data available for 1996, 1999, 2002, 2003"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Australia'",
                      "Data available for 1994"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Austria'",
                      "Data available for 2000"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Azerbaijan'",
                      "Data available for 1995, 2001, 2005"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Bangladesh'",
                      "Data available for 1992, 1996, 2000, 2005"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Belarus'",
                      "Data available for 1988, 1993, 1997, 1998, 2000, 2002, 2005"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Belgium'",
                      "Data available for 2000"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Benin'",
                      "Data available for 2003"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Bhutan'",
                      "Data available for 2003"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Bolivia'",
                      "Data available for 1991, 1997, 1999, 2002, 2005"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Bosnia and Herzegovina'",
                      "Data available for 2001, 2004"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Botswana'",
                      "Data available for 1986, 1994, 1995"
                    ),
                    conditionalPanel(
                      condition = "input.countryInput == 'Brazil'",
                      "Data available for 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990, 1992, 1993, 1995, 1996, 1997, 1998, 1999, 2001, 2002, 2003, 2005, 2007"
                    )
                  ),
                  mainPanel(plotOutput("coolplot"),
                            tableOutput("results"))
                ))

server <- function(input, output) {
  filtered <- reactive({
    if(is.null(input$countryInput)) {
      return(NULL)
    }
    
    d %>%
      filter(
        year == input$yearInput,
        country == input$countryInput
      )
  })
  
  #I'm having particiular trouble getting these to render. Reactivity is mostly
  #what I'm having trouble with, as it seems even when I follow tutorials every
  #thing breaks down when applying it to this data.
  
  output$coolplot <- renderPlot({
    if (is.null(filtered())) {
      return()
    }
    
    ggplot(filtered, aes(x = variable, y = value)) +
      geom_bar(stat = "identity")
  })
  
  output$results <- renderTable({
    filtered()
  })
}

shinyApp(ui = ui, server = server)