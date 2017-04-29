library(tidyverse)
library(knitr)

data <- read.csv("../dataviz/submissions/Pennington_Brian/Assignment 2/Centrality Signal Detection.csv")

t.test(data$Pre.Test.HC, data$Post.Test.HC, paired = TRUE)
t.test(data$Pre.Test.LC, data$Post.Test.LC, paired = TRUE)
t.test(data$Pre.Test.HC, data$Pre.Test.LC)
t.test(data$Post.Test.HC, data$Post.Test.LC)
 