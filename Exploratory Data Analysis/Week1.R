# ---- Week 1: Exploratory Data Analysis ----
# 
# Notes and code taken from R. Peng's lecture slides (Credit: https://class.coursera.org/exdata-006/)
#
# PM2.5 data sources
#   - Air Quality Standards: http://www.epa.gov/air/criteria.html
#   - Daily data on PM2.5: http://www.epa.gov/ttn/airs/airsaqs/detaildata/downloadaqsdata.htm
#
# Further resources:
#   - http://gallery.r-enthusiasts.com/
#   - http://www.r-bloggers.com/

setwd("~/Dropbox/Study/Data Science/datasciencecoursera/Exploratory Data Analysis/week1")

# ---- Exploratory graphics ----
#
# Question: Are there any counties in the U.S. that exceed that national standard for fine particle pollution?
#
pollution <- read.csv("data/avgpm25.csv", colClasses = c("numeric", "character", 
                                                         "factor", "numeric", "numeric"))
head(pollution)

# Five number summary (well, six really...)
summary(pollution$pm25)

# Boxplot
boxplot(pollution$pm25, col = "blue")

# Histogram 1
hist(pollution$pm25, col = "green", breaks = 100)
rug(pollution$pm25)

# Histogram 2
hist(pollution$pm25, col = "green")
abline(v = 12, lwd = 12)
abline(v = median(pollution$pm25), col = 'magenta', lwd = 4)

# Overlaying Features
boxplot(pollution$pm25, col = "blue")
abline(h = 12)

# Barplot
barplot(table(pollution$region), col = "wheat", main = "Number of Counties in Each Region")

# Multiple Boxplots ("pm25 by region")
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

# ---- Plotting Systems in R ----
#
# Three plotting systems
# 1. Base Plotting System: Original R system.
# 2. Lattice
# 3. GGPlot
#

# ---- Base Plotting System ----
#
# Graphics system in 'graphics' and 'grDevices'.
#
# Two phases:
#    1. Initialise new plot
#       - plot(x, y) or hist(x)
#       - many paramaters that can be set and tweaked. See ?par
#    2. Annotate existing plot
# 

library(datasets)
data(cars)
with(cars, plot(speed, dist))

# Initialise plot - plot(x, y) or hist(x)
#   pch: the plotting character (ie symbol) (default is open circle)
#   lty: the line type (default is solid line), can be dashed, etc
#   lwd: the line width (integer)
#   col: plotting color. See colors() for color names, or use integer or hex code.
#   xlab: x-axis label
#   ylab: y-axis label
#
# See also: par() function, which sets global graphics parameters that affect 
# all plots. Can also be specified in plotting functions.
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

airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)")

par("lty"); par("col")
par("bg"); par("mar"); par("mfrow")

# Annotate (add to) an existing plot
#
# plot: make a scatterplot, or other type of plot depending on the class of the object being plotted
# lines: add lines to a plot, given a vector x values and a corresponding vector of y values 
#        (or a 2-column matrix); this function just connects the dots
# points: add points to a plot
# text: add text labels to a plot using specified x, y coordinates
# title: add annotations to x, y axis labels, title, subtitle, outer margin
# mtext: add arbitrary text to the margins (inner or outer) of the plot
# axis: adding axis ticks/labels

# Plot with annotation (title)
?with
with(airquality, plot(Wind, Ozone))
title(main = "Ozone and Wind in New York City")  ## Add a title

# Plot with annotation (subset)
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City v2"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))

# Plot with annotation (legend)
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", 
                      type = "n"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red"))
legend("topright", pch = 1, col = c("blue", "red"), legend = c("May", "Other Months"))

# Base plot with regression line
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", 
                      pch = 20))
model <- lm(Ozone ~ Wind, airquality)  # linear model (lm)
abline(model, lwd = 2)

# Multiple Base Plots
par(mfrow = c(1, 2))
with(airquality, {
    plot(Wind, Ozone, main = "Ozone and Wind")
    plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
})

# Multiple Base Plots 2
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(airquality, {
    plot(Wind, Ozone, main = "Ozone and Wind")
    plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
    plot(Temp, Ozone, main = "Ozone and Temperature")
    mtext("Ozone and Weather in New York City", outer = TRUE)
})

# ---- Base Plotting Demonstration ----
#
par(mfrow = c(1,1))
x <- rnorm(100)
hist(x)
y <- rnorm(100)
plot(x,y)

# margin 1 = bottom, 2 = left; 3 = top; 4 = right
par(mar = c(4, 4, 2, 2))
plot(x, y)
plot(x, y, pch = 20)  # solid dots
plot(x, y, pch = 19)  # fat dots
plot(x, y, pch = 2)   # triangles

# See also: 
example(points)
pchShow()
pchShow(c("o", "O", "0"), cex = 2.5)

# Example continued...
x <- rnorm(100)
y <- rnorm(100)
plot(x, y, pch=20)
title("Scatterplot")
text(-2, -2, "Label") # x,y refers to plot co-ords
legend("topleft", legend = "Data", pch = 2)
fit <- lm(y ~ x)
abline(fit, lwd = 3, col = "blue")

plot(x, y, xlab = "Weight", ylab = "Height", main = "Scatterplot",
     pch = 20)
legend("topright", legend = "Data", pch = 20)
fit <- lm(y ~ x)
abline(fit, lwd = 3, col = "red")

# Two plots
z <- rpois(100, 2)
par(mfrow = c(2, 1), mar = c(2, 2, 1, 1))
plot(x, y, pch = 20)
plot(x, z, pch = 19)

# Four plots
par(mfrow = c(2, 2), mar = c(2, 2, 1, 1))
#par(mfcol = c(2, 2), mar = c(2, 2, 1, 1))
plot(x, y) # upper left
plot(x, z) # upper right
plot(z, x) # lower left
plot(y, x) # lower right
# if you use mfcol instead of mfrow, plots go in different order

# Adding labels
par(mfrow = c(1, 1), mar = c(4, 4, 2, 2))
x <- rnorm(100)
y <- x + rnorm(100)
g <- gl(2, 50, labels = c("Male", "Female"))
plot(x, y, type = "n")  # make the plot, but don't show the data
points(x[g == "Male"], y[g == "Male"], col = "blue", pch = 20)
points(x[g == "Female"], y[g == "Female"], col = "pink", pch = 19)
fit <- lm(x ~ y)
abline(fit)


# ---- Lattice ----
#
# 2. The Lattice System: Plots are created with single function call.
#   - Useful for conditioning plots (how y changes with x across levels of z)
#   - Can be awkward to specify an entire plot in a single function call
#   - Can't add to the plot once it's done
#
library(lattice)
state <- data.frame(state.x77, region = state.region)
xyplot(Life.Exp ~ Income | region, data = state, layout = c(4,1))


# ---- GGPlot ----
#
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



# ---- Graphics Devices ----
#
# A graphics device is something where you can make a plot appear
#   - A window on your computer (screen device)
#   - A PDF file (file device)
#   - A PNG or JPEG file (file device)
#   - A scalable vector graphics (SVG) file (file device)
# When you make a plot in R, it has to be "sent" to a specific graphics device
# (usually the screen). If you're sharing a plot, you probably want a file device
# instead.
#
?Devices

# Plotting to screen
library(datasets)
with(faithful, plot(eruptions, waiting))  ## Make plot appear on screen device
title(main = "Old Faithful Geyser data")  ## Annotate with a title

# Plotting to file
##setwd("~/Desktop")
pdf(file = "~/Desktop/myplot.pdf")  ## Open PDF device; create 'myplot.pdf' in my working directory
with(faithful, plot(eruptions, waiting))
title(main = "Old Faithful Geyser data") 
dev.off()  ## Close the PDF file device


# Graphics File Devices
#
# Vector formats:
#   - pdf: useful for line-type graphics, resizes well, usually portable, not efficient if a plot has many objects/points
#   - svg: XML-based scalable vector graphics; supports animation and interactivity, potentially useful for web-based plots
#   - win.metafile: Windows metafile format (only on Windows)
#   - postscript: older format, also resizes well, usually portable, can be used to create encapsulated postscript files; 
#     (Windows systems often don’t have a postscript viewer)
#
# Bitmap formats
#   - png: bitmapped format, good for line drawings or images with solid colors, 
#   - jpeg: good for photographs or natural scenes, uses lossy compression, 
#   - tiff: Creates bitmap files in the TIFF format; supports lossless compression
#   - bmp: a native Windows bitmapped format
#
# Can plot to multiple devices. Plotting can only occur on one graphics device at a time.
# The currently active graphics device can be found by calling dev.cur()
# You can change the active graphics device with dev.set(<integer>).

dev.cur()
dev.list()
dev.set(2)

# Can copy plots
#   - dev.copy: copy a plot from one device to another
#   - dev.copy2pdf: specifically copy a plot to a PDF file
#
library(datasets)
with(faithful, plot(eruptions, waiting))
title(main = "Old Faithful Geyser data")
dev.copy(png, file = "~/Desktop/geyserplot.png")  ## Copy my plot to a PNG file
dev.off()  ## Don't forget to close the PNG device!
