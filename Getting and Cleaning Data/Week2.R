setwd("~/Dropbox/Study/Getting and Cleaning Data")

# MySQL
install.packages("RMySQL")

# HDF5
source("http://bioconductor.org/biocLite.R")
biocLite("rhdh5")
library(rhdh5)
created = h5createFile("example.h5")
