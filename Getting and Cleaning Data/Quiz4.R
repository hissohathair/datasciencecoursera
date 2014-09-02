# Quiz 4
#    Code for finding the answers to Week 3 quiz
#

setwd("~/Dropbox/Study/Data Scientist's Toolbox/datasciencecoursera/Getting and Cleaning Data/week4")

printf <- function(...) invisible(print(sprintf(...)))
cacheLoad <- function(url, localFile) {
    if ( file.exists(localFile)) {
        printf("Using cached version of %s", localFile)
    }
    else {
        printf("Downloading data for %s...", localFile)
        download.file(url, destfile = localFile, method="curl", cacheOK = TRUE, quiet = TRUE)
        dateDownloaded <- date()
    }
    return(localFile)
}

# Question 1
#
ssdata <- read.csv(cacheLoad("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "getdata-data-ss06hid.csv"))
splitNames <- strsplit(names(ssdata), "wgtp")
splitNames[123]


# Question 2
#
gdpdata <- read.csv(cacheLoad("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "getdata-data-GDP.csv"),
				skip = 5, nrows = 190, as.is = TRUE, header = FALSE)
str(gdpdata)
mean(as.numeric(gsub(",", "", gdpdata$V5)))


# Question 3
#
grep("^United", gdpdata$V4)


# Question 4
#
eddata <- read.csv(cacheLoad("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "getdata-data-EDSTATS_Country.csv"))
merged <- merge(gdpdata, eddata, by.x = "V1", by.y = "CountryCode", all = FALSE)
str(merged)
length(grep("Fiscal year end: June", merged$Special.Notes, ignore.case = TRUE))


# Question 5
#
if ( !require("quantmod") ) {
	install.packages("quantmod")
}
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
str(sampleTimes)
dateRange = as.Date(c("1jan2012", "31dec2012"), "%d%b%Y")
length(sampleTimes[sampleTimes >= dateRange[1] & sampleTimes <= dateRange[2]])
length(sampleTimes[sampleTimes >= dateRange[1] & sampleTimes <= dateRange[2] & weekdays(sampleTimes) == "Monday"])
