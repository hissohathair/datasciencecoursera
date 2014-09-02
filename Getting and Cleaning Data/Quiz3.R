# Quiz 3
#    Code for finding the answers to Week 3 quiz
#

setwd("~/Dropbox/Study/Data Scientist's Toolbox/datasciencecoursera/Getting and Cleaning Data/week3")

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
#   ACR == 3 (Houses on > 10 acres)
#   AGS == 6 (Sold > $10K)
#
csvdata <- read.csv(cacheLoad("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "ss06hid.csv"))
agricultureLogical <- csvdata$ACR == 3 & csvdata$AGS == 6
print(which(agricultureLogical))


# Question 2
#
if ( !require("jpeg")) {
    install.packages("jpeg")
}
library(jpeg)
jpgData <- readJPEG(cacheLoad("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg", "jeff.jpg"), native = TRUE)
print(quantile(jpgData, probs=c(0.3,0.8)))


# Question 3
#   GDP: http://data.worldbank.org/data-catalog/GDP-ranking-table
#   Ed Stats: http://data.worldbank.org/data-catalog/ed-stats
#
library(plyr)
gdpData <- read.csv(cacheLoad("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "GDP.csv"),                  
                    quote = '"', skip = 5, header = FALSE, as.is = TRUE, nrows = 190)
gdpStats <- gdpData[gdpData$V2 >= 1,]
edStats <- read.csv(cacheLoad("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "FEDSTATES_Country.csv"),
                              header = TRUE, as.is = TRUE)

# Country code is "V1" in gdpData; and "CountryCode" in edStats
merged <- merge(gdpStats, edStats, by.x = "V1", by.y = "CountryCode", all = FALSE)
sorted <- arrange(merged, V2, decreasing = TRUE)
print(sorted[13,c("V2","V4")])


# Question 4
# 
fixed <- transform.data.frame(sorted, V2 = as.numeric(gsub(x = V2, pattern = ",", replacement = "")))
printf("OECD mean: %f", mean(fixed[fixed$Income.Group == "High income: OECD", "V2"]))
printf("Non-OECD mean: %f", mean(fixed[fixed$Income.Group == "High income: nonOECD", "V2"]))


# Question 5
#
if ( !require("survival")) { install.packages("survival") }
if ( !require("Hmisc"))    { install.packages("Hmisc") }
library(Hmisc)
cut2(fixed$V2, g = 5)
fixed[fixed$V2 <= 38 & fixed$Income.Group == "Lower middle income", "V1"]