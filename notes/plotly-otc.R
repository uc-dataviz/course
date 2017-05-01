library(tidyverse)
library(stringr)
library(plotly)
library(rJava)
library(XLConnect)

options(digits = 3)
set.seed(1234)
theme_set(theme_minimal())


# function to convert outputs to tidy data frame
tidy_outputs <- function(outputs){
  outputs %>%
    as_tibble %>%
    gather(year, value, -Revenue.effect, convert = TRUE) %>%
    mutate(year = parse_number(year),
           Revenue.effect = factor(Revenue.effect,
                                   levels = c("User Model",
                                              "The Joint Committee on Taxation",
                                              "The Lindsey Group")))
}

# load model workbook and default inputs and outputs
# sorry i cannot share this file with you - it's proprietary
model <- loadWorkbook("data/OTCModelFeb2017rev5-Widget.xlsx")
model_inputs <- readWorksheet(model, "R-in")

# create color palette for graph
cbbpal <- c('#1b9e77', '#d95f02', '#7570b3')

# generate data
model_data <- tidy_outputs(readWorksheet(model, "R-out"))
model_data

# generate basic graph
g <- model_data %>%
  rename(Year = year, `Revenue effect` = value, `Model` = Revenue.effect) %>%
  ggplot(aes(Year, `Revenue effect`, color = Model)) +
  geom_line(size = 1.5) +
  scale_color_manual(values = cbbpal) +
  guides(color = guide_legend(nrow = 1)) +
  labs(x = "Year",
       y = "Millions (USD)",
       color = NULL) +
  theme_minimal(base_size = 14)

# static version
g

# plotly version
p <- plotly_build(g)
p

# view legend components
p$x$layout$legend

# fix legend position
p$x$layout$legend$x <- .5
p$x$layout$legend$y <- -.3
p$x$layout$legend$xanchor <- "center"
p$x$layout$legend$yanchor <- "top"
p$x$layout$legend$orientation <- "h"

p

# view structure
p$x$data[[1]]

# need to change the $text element - written in html
p$x$data[[1]]$text <- str_replace_all(p$x$data[[1]]$text,
                                      pattern = "`Revenue effect`", "Revenue effect")
p$x$data[[2]]$text <- str_replace_all(p$x$data[[2]]$text,
                                      pattern = "`Revenue effect`", "Revenue effect")
p$x$data[[3]]$text <- str_replace_all(p$x$data[[3]]$text,
                                      pattern = "`Revenue effect`", "Revenue effect")

p
