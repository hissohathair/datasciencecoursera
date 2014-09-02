# Week 4
#

setwd("~/Dropbox/Study/Data Scientist's Toolbox/datasciencecoursera/Getting and Cleaning Data/week4")

# Helper functions
#
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


# Sample data for examples
#
mylist     <- list(letters = c("A", "b", "c"), numbers = 1:3, matrix(1:25, ncol = 5))
cameraData <- read.csv(cacheLoad("https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD", "cameras.csv"))
reviews    <- read.csv(cacheLoad("https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv", "reviews.csv"))
solutions  <- read.csv(cacheLoad("https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv", "solutions.csv"))


# String manipulation
#
names(cameraData) 
tolower(names(cameraData))
splitNames = strsplit(names(cameraData), "\\.")
splitNames[5]; splitNames[[6]][1]

firstElement <- function(x){ x[1] }
sapply(splitNames, firstElement)


# Accessing elements
#
head(mylist)
mylist$letters
mylist$numbers
mylist[[3]]

head(reviews, 2)
head(solutions, 2)


# Fixing character vectors - sub()
#
names(reviews)
sub("_", "", names(reviews),)
testName <- "this_is_a_test"
sub("_", "", testName)  # [1] "thisis_a_test"
gsub("_", "", testName) # [1] "thisisatest"


# Finding values - grep(), grepl()
#
grep("Alameda", cameraData$intersection)  # [1]  4  5 36
table(grepl("Alameda",cameraData$intersection))
cameraData2 <- cameraData[!grepl("Alameda",cameraData$intersection),]

# See also http://www.biostat.jhsph.edu/~ajaffe/lec_winterR/Lecture%203.pdf
grep("Alameda", cameraData$intersection, value=TRUE)
grep("JeffStreet", cameraData$intersection) # integer(0)
length(grep("JeffStreet", cameraData$intersection)) # [1] 0


# More useful string functions
#
library(stringr)
nchar("Jeffrey Leek")       # [1] 12
substr("Jeffrey Leek",1,7)  # [1] "Jeffrey"
paste("Jeffrey","Leek")     # [1] "Jeffrey Leek"
paste0("Jeffrey","Leek")    # [1] "JeffreyLeek"
str_trim("Jeff      ")      # [1] "Jeff"


# Important points about text in data sets
#
# Names of variables should be
# 	- All lower case when possible
#	- Descriptive (Diagnosis versus Dx)
#	- Not duplicated
#	- Not have underscores or dots or white spaces
#
# Variables with character values
#	- Should usually be made into factor variables (depends on application)
#	- Should be descriptive (use TRUE/FALSE instead of 0/1 and Male/Female versus 0/1 or M/F)
#

# Regex
#	- Meta chars:
#		^			start of a line
#		$			end of a line
#		a|b			means "a or b"
#		^[Gg]ood|[Bb]ad	means begins "good" or as "bad" in it
#		^([Gg]ood|[Bb]ad)	means begings "good" or begins "bad"
#		?			item is optional
#		\			next char is quoted literal
#		*			zero or more (greedy matching)
#		*?			zero or more (don't be greedy)
#		+			one or more
#		{m}			means exactly m matches
#		{m,n}			repeats min <= N <= n times
#		{m,}			means at least m times
#
#	- Character classes
#		[Bb][Uu][Ss][Hh]	means "bush" with any capitalisation
#		[0-9][a-zA-Z]	means digit, then letter
#		[^a-z]		means "not a-z"
#		.			means "any char"
#
#	- Backticks
#		()			remeber the text that matches between these
#		\1, \2		recall first, second matching text
#


# Working with Dates
#
d1 = date()
d1
class(d1)

d2 = Sys.Date()
d2
class(d2)

format(d2, "%a %b %d")
z = as.Date(c("1jan1960", "2jan1960"), "%d%b%Y")
z[2] - z[1]
weekdays(d2)
months(d2)
julian(d2)

if ( !require("lubridate") ) {
	install.packages("lubridate")
}
library(lubridate)
ymd("20140108")
mdy("08/04/2013")
x = ymd_hms("2011-08-13 10:15:03", tz="Pacific/Auckland")
wday(x, label = TRUE)

# POSIXct, POSIXlt