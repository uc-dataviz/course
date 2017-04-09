# This file executes all the files ???

# Cleans existing files and directories and creates new directores.
paths <- c("./data/tidy_data", "./graphics")

#, "output"

for (path in paths) {
    unlink(path, recursive = TRUE) 
    dir.create(path)
}

source("01_get_clean_data.R")
source("02_exploratory_analysis.R")
source("03_models.R")
rmarkdown::render("04_report.Rmd", output_dir = "output")