# Cleans existing files and directories and creates new directores.
paths <- c("./data", "./graphics")

for (path in paths) {
    unlink(path, recursive = TRUE) 
    dir.create(path)
}

source("00_download_data.R")
source("01_clean_data.R")


