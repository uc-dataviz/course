library(shiny)
library(tidyverse)

# load the data (retrieve and clean raw data if this is the first time)
filename <- file.path("data", "abc.csv")
if (file.exists(filename)) {
  abc <- read_csv(filename)
} else {
  # get and clean data
  abc <- read_csv("https://raw.githubusercontent.com/bensoltoff/Virginia-ABC-Data/master/virginia-abc-pricelist.csv") %>%
    # trim variables
    select(ProductName, CurrentPrice, Description, FamilyBrand,
           HierarchyCategory, HierarchyClass,
           Proof, Size) %>%
    rename(Type = HierarchyClass,
           Subtype = HierarchyCategory) %>%
    # remove duplicates
    group_by(ProductName) %>%
    slice(1) %>%
    ungroup
  
  # extract size component and convert to metric
  abc <- abc %>%
    separate(Size, into = c("Size", "Unit"), sep = " ", convert = TRUE) %>%
    mutate(Size = if_else(Unit == "L", Size * 1000, Size),
           Size = if_else(Unit == "oz", Size * 29.5735, Size)) %>%
    select(-Unit)
  
  # add proof category
  abc <- abc %>%
    mutate(ProofBin = cut(Proof, breaks = c(-Inf, 40, 80, 120, 160, 200),
                          labels = c("0-40", "40-80", "80-120", "120-160", "160+")))
  
  write_csv(abc, filename)
}


ui <- fluidPage(
  titlePanel("Virginia ABC Store prices"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        "priceInput",
        "Price",
        min = 0,
        max = 100,
        value = c(25, 40),
        pre = "$"
      ),
      radioButtons(
        "typeInput",
        "Product type",
        choices = c("Mixers", "Rimmers", "Spirits", "Wine"),
        selected = "Spirits"
      ),
      selectInput(
        "proofInput",
        "Proof",
        choices = c("0-40", "40-80", "80-120", "120-160", "160+")
      ),
      uiOutput("subtypeInput")
    ),
    mainPanel(h3(textOutput("summaryText")),
              br(),
              plotOutput("plot"),
              br(), br(),
              DT::dataTableOutput("results"))
  ))

server <- function(input, output) {
  filtered <- reactive({
    if(is.null(input$subtypeInput)) {
      return(NULL)
    }
    
    products <- abc %>%
      filter(
        CurrentPrice >= input$priceInput[1],
        CurrentPrice <= input$priceInput[2],
        Type == input$typeInput,
        ProofBin == input$proofInput,
        Subtype == input$subtypeInput
      )
    
    if(nrow(products) == 0) {
      return(NULL)
    }
    
    products
  })
  
  output$summaryText <- renderText({
    numOptions <- nrow(filtered())
    if (is.null(numOptions)) {
      numOptions <- 0
    }
    stringr::str_c("We found ", numOptions, " options for you")
  })
  
  output$subtypeInput <- renderUI({
    selectInput("subtypeInput", "Subtype",
                sort(unique(abc$Subtype)),
                selected = "Whiskey")
  })
  
  output$plot <- renderPlot({
    if (is.null(filtered())) {
      return()
    }
    
    ggplot(filtered(), aes(Size)) +
      geom_histogram() +
      theme_bw(base_size = 20) +
      labs(x = "Size (in mL)",
           y = "Number of products")
  })
  
  output$results <- DT::renderDataTable({
    if (is.null(filtered())) {
      return()
    }
    
    filtered() %>%
      select(ProductName, CurrentPrice, Description, Type, Subtype, Size,
             Proof) %>%
      mutate(Size = stringr::str_c(Size, "ml", sep = " "))
  })
}

shinyApp(ui = ui, server = server)
