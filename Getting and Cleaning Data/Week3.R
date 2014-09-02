# Week 3 Lecture Notes
#
# See also: http://www.biostat.jhsph.edu/~ajaffe/lec_winterR/Lecture%202.pdf
#
# Sample data, creates a new data frame "X" with 3 columns named
# var1, var2 & var3
#
set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X <- X[sample(1:5),]; X$var2[c(1,3)] = NA
print(X)

# Print the values from column 1
X[,1]
# [1] 2 1 3 5 4

# Same as above, using column name
X[,"var1"]
# [1] 2 1 3 5 4

# Print first two rows from column var2
X[1:2,"var2"]
# [1] NA 10

# Select using logical expressions
#   Select rows where value in var1 <= 3 AND value in var3 > 11
X[(X$var1 <= 3 & X$var3 > 11),]
#   var1 var2 var3
# 1    2   NA   15
# 2    3   NA   12

#   Select rows where value in var1 <= 3 OR value in var3 > 15
X[(X$var1 <= 3 | X$var3 > 15),]
#   var1 var2 var3
# 1    2   NA   15
# 4    1   10   11
# 2    3   NA   12

# Use which() to detail with NAs
X[which(X$var2 > 8),]
#   var1 var2 var3
# 4    1   10   11
# 5    4    9   13

# Sorting
sort(X$var1)
sort(X$var1,decreasing=TRUE)
sort(X$var2,na.last=TRUE)

# Ordering
X[order(X$var1),]
#   var1 var2 var3
# 4    1   10   11
# 1    2   NA   15
# 2    3   NA   12
# 5    4    9   13
# 3    5    6   14

# Or use plyr
library(plyr)
arrange(X,var1)

# Adding columns (by using a new column name)
X$var4 <- rnorm(5)
Y <- cbind(X,rnorm(5))
print(Y)

# Adding rows
Z <- rbind(X,rnorm(5))
print(Z)

# Summarising data
#
setwd("~/Dropbox/Study/Data Scientist's Toolbox/datasciencecoursera/Getting and Cleaning Data/data")
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
if ( !file.exists("restaurants.csv")) { 
    download.file(fileUrl, destfile="restaurants.csv", method="curl")
}
restData <- read.csv("restaurants.csv")

head(restData,n=3)
tail(restData,n=3)
summary(restData)
str(restData)
quantile(restData$councilDistrict,na.rm=TRUE)
quantile(restData$councilDistrict,probs=c(0.5,0.75,0.9))

# Make table
table(restData$zipCode, useNA="ifany")
table(restData$councilDistrict,restData$zipCode)

# Check for missing values
sum(is.na(restData$councilDistrict))  # 0 would mean no missing values
any(is.na(restData$councilDistrict))  # FALSE would mean no NAs
all(restData$zipCode > 0)   # check that all values match condition

# Rows and columns sums
colSums(is.na(restData))
all(colSums(is.na(restData))==0)

# Values with specific characterisitcs
table(restData$zipCode %in% c("21212"))
table(restData$zipCode %in% c("21212","21213"))
restData[restData$zipCode %in% c("21212","21213"),]

# Crosstabs
data(UCBAdmissions)
DF = as.data.frame(UCBAdmissions)
summary(DF)

xt <- xtabs(Freq ~ Gender + Admit, data=DF) # Frequency that males/females admitted/rejected
xt

# Flat tables
warpbreaks$replicate <- rep(1:9, len = 54)
xt = xtabs(breaks ~.,data=warpbreaks)
xt
ftable(xt)

# Size of data set
fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData),units="Mb")

