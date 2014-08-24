# Week 1, Quiz 1

library(data.table)
library(xlsx)
library(XML)

setwd("~/Dropbox/Study/Getting and Cleaning Data")
dataDir <- "./week1"
if ( !file.exists(dataDir) ) { dir.create("dataDir") }


# Question 1
#
csvUrl  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
codeUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"

csvFile  <- paste(dataDir, "community.csv", sep="/")
codeFile <- paste(dataDir, "code_book.pdf", sep="/")
if ( !file.exists(csvFile) ) {
  download.file(fileUrl, destfile = "./week1/community.csv", method="curl")
}
if ( !file.exists(codeFile) ) {
  download.file(codeBook, destfile = "./week1/code_book.pdf", method = "curl")  
}

data <- fread(csvFile)
newdata <- subset(data, VAL==24, select=c(SERIALNO,VAL))
dim(newdata)


# Question 3
#   original data source: http://catalog.data.gov/dataset/natural-gas-acquisition-program
#
gasUrl  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
gasFile <- paste(dataDir, "natural_gas.xlsx", sep="/")
if ( !file.exists(gasFile)) {
  download.file(gasUrl, destfile = gasFile, method = "curl", mode="wb")
}
rowIndex <- 18:23
colIndex <- 7:15
dat <- read.xlsx(gasFile, sheetIndex=1, header=TRUE, colIndex=colIndex, rowIndex=rowIndex)
sum(dat$Zip * dat$Ext, na.rm=T) 


# Question 4
#
baltimoreUrl  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
baltimoreFile <- paste(dataDir, "baltimore.xml", sep="/")
if ( !file.exists(baltimoreFile)) {
  download.file(baltimoreUrl, destfile = baltimoreFile, method="curl")
}

xmlDoc <- xmlTreeParse(baltimoreFile, useInternal=TRUE)
rootNode <- xmlRoot(xmlDoc)
xpathSApply(rootNode, "/response/row/row[zipcode=21231]", xmlValue)


# Question 5
#
idahoUrl  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
idahoFile <- paste(dataDir, "idaho.csv", sep="/")
if ( !file.exists(idahoFile)) {
  download.file(idahoUrl, destfile=idahoFile, method="curl")
}

DT = fread(idahoFile)

print("a")
#system.time(  mean(DT$pwgtp15,by=DT$SEX)  )  ## does not work!
print("b")
system.time(  tapply(DT$pwgtp15,DT$SEX,mean)  )
print("c")
system.time(  mean(DT[DT$SEX==1,]$pwgtp15)  ); system.time(  mean(DT[DT$SEX==2,]$pwgtp15)  )
print("d")
system.time(  sapply(split(DT$pwgtp15,DT$SEX),mean)  )
print("e")
#system.time(  rowMeans(DT)[DT$SEX==1]); system.time(rowMeans(DT)[DT$SEX==2]  )  ## does not work!
print("f")
system.time(  DT[,mean(pwgtp15),by=SEX]  )
