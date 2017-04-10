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
rmarkdown::render("02_report.Rmd", output_dir = "output")