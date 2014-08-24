# Working file for Getting and Cleaning data
#
# install.packages("xlsx")
# install.packages("XML")
# install.packages("jsonlite")
# install.packages("data.table")

# Data source URLs
#
fileUrl  <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
excelUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
xmlUrl   <- "http://www.w3schools.com/xml/simple.xml"
htmlUrl  <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
jsonUrl  <- "https://api.github.com/users/jtleek/repos"


# Internal working variables
#
setwd("~/Dropbox/Study/Getting and Cleaning Data")
cacheDir <- "./data"
if ( !file.exists(cacheDir) ) {
  dir.create(cacheDir)
}

# Load CSV ata
#
csvFile <- paste(cacheDir, "cameras.csv", sep = "/")
if ( !file.exists(csvFile)) {
  print("Downloading CSV data...")
  download.file(fileUrl, destfile = csvFile, method="curl")
  csvDateDownloaded <- date()  
}
csvdata <- read.csv(csvFile)


# Load XLS data
#
library(xlsx)
xlsFile <- paste(cacheDir, "cameras.xlsx", sep = "/")
if ( !file.exists(xlsFile)) {
  print("Downloading XLS data...")
  download.file(excelUrl, destfile = xlsFile, method="curl")
  xlsDateDownloaded <- date()    
}
xlsdata <- read.xlsx(xlsFile, sheetIndex=1, header=TRUE)


# Load XML data
#
library(XML)
xmlDoc <- xmlTreeParse(xmlUrl, useInternal=TRUE)
rootNode <- xmlRoot(xmlDoc)
# xmlName(rootNode)
# xpathSApply(rootNode, "//name", xmlValue)


# Load HTML data
#
htmlDoc <- htmlTreeParse(htmlUrl, useInternal=TRUE)
scores <- xpathSApply(htmlDoc, "//li[@class='score']", xmlValue)
teams <- xpathSApply(htmlDoc, "//li[@class='team-name']", xmlValue)


# Load JSON data
#
library(jsonlite)
jsonData <- fromJSON(jsonUrl)
names(jsonData$owner)
# myjson <- toJSON(iris, pretty=TRUE)
# iris2 <- fromJSON(myjson)


# Data Tables
#
library(data.table)
DT <- data.table(x=rep(c("a","b","c"), each=100), y=rnorm(300))
setkey(DT, x)
DT['a']

# Joins
DT1 <- data.table(x=c('a','a','b','dt1'), y=1:4)
DT2 <- data.table(x=c('a','b','dt2'), z=5:7)
setkey(DT1, x); setkey(DT, x)
merge(DT1, DT2)

# Fast reading
big_df <- data.frame(x=rnorm(1E6), y=rnorm(1E6))
file <- tempfile()
write.table(big_df, file=file, row.names=FALSE, col.names=TRUE, sep="\t",quote=FALSE)
system.time(fread(file))
system.time(read.table(file, header=TRUE, sep="\t"))
