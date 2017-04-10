###############################################################
# Data Vizualization
# Assigment One
# Camacho Jonathan E.
###############################################################
# This script initialize directories "data," "graphics"
# Controls over all pipiline. Run scripts:
  # 01_tidying_data.R

###############################################################

# Cleans existing files and directories and creates new directores.
paths <- c("./data/", "./graphics")

#, "output"

for (path in paths) {
    unlink(path, recursive = TRUE) 
    dir.create(path)
}

source("01_processing.R")
# source("02_exploratory_analysis.R")
# source("03_models.R")
# rmarkdown::render("04_report.Rmd", output_dir = "output")