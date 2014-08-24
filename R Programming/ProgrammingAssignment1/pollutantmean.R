# Assignemnt 1, File 1
#
# Data files: https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2Fspecdata.zip
#

##setwd("~/Dropbox/Study/R Programming/assignment1")
##dataDir <- "specdata"

pollutantmean <- function(directory, pollutant, id = 1:332) {
    # 'directory' is a character vector of length 1 indicating
    # the location of the CSV files
    #
    # 'pollutant' is a character vector of length 1 indicating
    # the name of the pollutant for which we will calculate the
    # mean; either "sulfate" or "nitrate".
    #
    # 'id' is an integer vector indicating the monitor ID numbers
    # to be used
    #
    # Return the mean of the pollutant across all monitors list
    # in the 'id' vector (ignoring NA values)
    #

    data <- data.frame()
    for (i in id) {
        # create the filename
        filename <- paste(directory, "/", sprintf("%03d", i), ".csv", sep = "")
        filedata <- read.csv(filename, header=TRUE)
        data <- rbind(data, filedata)
    }
    mean(as.matrix(data[pollutant]), na.rm=TRUE)
}

# Test
## pollutantmean("specdata", "sulfate", 1:10)  ## [1] 4.064
## pollutantmean("specdata", "nitrate", 70:72) ## [1] 1.706
## pollutantmean("specdata", "nitrate", 23)    ## [1] 1.281

