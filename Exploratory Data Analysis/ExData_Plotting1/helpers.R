# helpers.R
#
# Helper functions for Plotting assignment
#

setwd("~/Dropbox/Study/Data Science/datasciencecoursera/Exploratory Data Analysis/ExData_Plotting1")


# printf: Similar to C's printf to make diagnostic messages easier
#
printf <- function(...) invisible(message(sprintf(...)))


# cacheLoad: Given a URL and a local file name, download the URL if the local file
# does not already exist.
#
cacheLoad <- function(url, localFile, ...) {
    if ( file.exists(localFile)) {
        printf("Using cached version of %s", localFile)
    }
    else {
        printf("Downloading data for %s...", localFile)
        download.file(url, destfile = localFile, method="curl", cacheOK = TRUE, quiet = TRUE, ...)
        dateDownloaded <- date()
    }
    return(localFile)
}


# fetchData: Load the data required for this assignment
#
fetchData <- function(zipUrl, fileName) {
    zipFile  <- cacheLoad(zipUrl, paste(fileName, "zip", sep = "."))
    txtFile  <- paste(fileName, "txt", sep = ".")                     
    if ( file.exists(txtFile)) {
        printf("Data file %s already unzipped.", zipFile)
    }  else {
        printf("Unzipping %s...", zipFile)
        unzip(zipFile, exdir = "./data")
    }
    return(txtFile)
}


# loadData: Given a local file name, load the data relevant to this assignment. Defaults
# are chosen specific to Peer Assignment 1, from week 1 of the course.
#
loadData <- function(fileName, nrows = 2075260, dateRange = c("2007-02-01", "2007-02-02"), ...) {
    
    # Tips for loading large data files from http://www.biostat.jhsph.edu/~rpeng/docs/R-large-tables.html
    #   - Specify column classes. We get the first 5 rows to guess the column classes.
    #   - Specify number of rows, so that R can correctly allocate enough memory
    #   - Also using read.delim which defaults to header=TRUE and comment.char="",
    #     the latter parameter speeding up read.table.
    #
    first5rows <- read.delim(dataFile, nrows = 5, sep = ";")
    classes <- c("character", "character", rep("numeric",7))  # sapply(first5rows, class)
    printf("Reading %d rows from %s...", nrows, fileName)
    data <- read.delim(dataFile, sep = ";", colClasses = classes, nrows = nrows, na.strings = "?", ...)
    
    # Convert dates and times
    printf("Fixing columns and subsetting data between %s to %s", dateRange[1], dateRange[2])    
    data$Time <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")
    data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
    
    # Get subset of data
    dateRange <- as.Date(dateRange, format = "%Y-%m-%d")
    subData <- subset(data, Date %in% dateRange)
    return(subData)
}

