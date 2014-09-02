# Week 1
#
# PM2.5 data sources
#   - Air Quality Standards: http://www.epa.gov/air/criteria.html
#   - Daily data on PM2.5: http://www.epa.gov/ttn/airs/airsaqs/detaildata/downloadaqsdata.htm
#
# Question: Are there any counties in the U.S. that exceed that national standard for fine particle pollution?
#
# Further resources:
#   - http://gallery.r-enthusiasts.com/
#   - http://www.r-bloggers.com/

setwd("~/Dropbox/Study/Data Science/datasciencecoursera/Exploratory Data Analysis/week1")
pollution <- read.csv("data/avgpm25.csv", colClasses = c("numeric", "character", 
                                                         "factor", "numeric", "numeric"))
head(pollution)

# Five number summary (well, six really...)
summary(pollution$pm25)

# Boxplot
boxplot(pollution$pm25, col = "blue")

# Histogram
hist(pollution$pm25, col = "green")
rug(pollution$pm25)

# Overlaying Features
boxplot(pollution$pm25, col = "blue")
abline(h = 12)

# Barplot
barplot(table(pollution$region), col = "wheat", main = "Number of Counties in Each Region")

# Multiple Boxplots
boxplot(pm25 ~ region, data = pollution, col = "red")

# Multiple Histograms
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
hist(subset(pollution, region == "east")$pm25, col = "green")
hist(subset(pollution, region == "west")$pm25, col = "purple")

# Scatterplot
with(pollution, plot(latitude, pm25, col = region))
abline(h = 12, lwd = 2, lty = 2)

# Multiple Scatterplots
par(mfrow = c(1, 2), mar = c(5, 4, 2, 1))
with(subset(pollution, region == "west"), plot(latitude, pm25, main = "West"))
with(subset(pollution, region == "east"), plot(latitude, pm25, main = "East"))

# Three plotting systems
# 1. Base Plotting System: Original R system.
#
library(datasets)
data(cars)
with(cars, plot(speed, dist))

# Initialise plot - plot(x, y) or hist(x)
#   pch: the plotting symbol (default is open circle)
#   lty: the line type (default is solid line), can be dashed, etc
#   lwd: the line width (integer)
#   col: plotting color. See colors() for color names, or use integer or hex code.
#   xlab: x-axis label
#   ylab: y-axis label
#
# See also: ?par, which sets global graphics parameters that affect all plots
#   las: Orientation of axis labels
#   bg: background color
#   mar: margin size
#   oma: outer margin size (default 0)
#   mfrow: number of plots per row, column (plots filled row-wise)
#   mfcol: number of plots per row, column (plots filled col-wise)
#
hist(airquality$Ozone)
with(airquality, plot(Wind, Ozone))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)")

par("bg"); par("mar"); par("mfrow")

# Annotate (add to) an existing plot


# 2. The Lattice System: Plots are created with single function call.
#   - Useful for conditioning plots
#   - Can be awkward to specify an entire plot in a single function call
#   - Can't add to the plot once it's done
#
library(lattice)
state <- data.frame(state.x77, region = state.region)
xyplot(Life.Exp ~ Income | region, data = state, layout = c(4,1))

# 3. The ggplot2 System
#   - Grammar for implementing plots
#   - Allows additions and annotations
#   - Aestehtics are done automatically, but you can customise
#
if ( !require("ggplot2")) {
    install.packages("ggplot2")
}
library(ggplot2)
data(mpg)
qplot(displ, hwy, data = mpg)