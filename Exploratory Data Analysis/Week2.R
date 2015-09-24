# ---- Week 2: Lattice & ggplot2 ----
#
# Notes from R.Peng's lectures at https://class.coursera.org/exdata-032/lecture
#
# The lattice plotting system is implemented using the following packages:
#    - lattice: contains code for producing Trellis graphics, 
#      includes functions like xyplot, bwplot, levelplot
#    - grid: implements a different graphing system independent of the “base” system; 
#      the lattice package builds on top of grid
#
# The lattice plotting system does not have a "two-phase" aspect with separate 
# plotting and annotation like in base plotting. All plotting/annotation is done at 
# once with a single function call
#
# ---- Lattice Functions ----
#
# xyplot: this is the main function for creating scatterplots
# bwplot: box-and-whiskers plots (“boxplots”)
# histogram: histograms
# stripplot: like a boxplot but with actual points
# dotplot: plot dots on "violin strings"
# splom: scatterplot matrix; like pairs in base plotting system
# levelplot, contourplot: for plotting "image" data
#
# Generally, take a formula for the first argument of the form:
#    xyplot(y ~ x | f * g, data)
# y (left of ~) is the y-axis variable
# x (right of ~) is the x-axis variable
# f and g and conditioning variables (optional). "*" indicates an interaction.
# data is the data frame from which to source the data.
#
# Example:
library(lattice)
library(datasets)
xyplot(Ozone ~ Wind, data=airquality)

# Panel plot:
airquality <- transform(airquality, Month=factor(Month))
xyplot(Ozone ~ Wind | Month, data=airquality)

# Lattice graphics functions return an object of type ''trellis''. The default
# print method will render it, but you can also assign to a variable.
#
p <- xyplot(Ozone ~ Wind, data = airquality)  ## Nothing happens!
print(p)

# ---- Lattice Panel Functions ----
#
# Panel functions control what happens in each panel. Lattice provides
# defaults, or you can specify your own functions.
#
set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2, 1))  ## Plot with 2 panels

## Custom panel function: adding a median
xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)  ## First call the default panel function for 'xyplot'
  panel.abline(h = median(y), lty = 2)  ## Add a horizontal line at the median
})

## Custom panel function: adding regression line
xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)  ## First call default panel function
  panel.lmline(x, y, col = 2)  ## Overlay a simple linear regression line
})


# ---- GGPlot2 ----
#
# Implementation of "The Grammar of Graphics" by Leland Wilkinson.
# Library written by Hadley Wickham. See http://ggplot2.org
#
# Start with qplot() -- rough analogue to plot(). Plots are made up of
# aesthetics (size, shape, colour) and geoms (points, lines). ggplot()
# is the base function and useful for doing things qplot() can't do.
#
# Example:
library(ggplot2)
str(mpg)
# qplot(x coord, y coord, data=dataframe)
qplot(displ, hwy, data=mpg) 

## Modifying aesthetics
qplot(displ, hwy, data=mpg, color=drv)

## Adding a geom
qplot(displ, hwy, data=mpg, geom=c("point","smooth"))

## Histograms
qplot(hwy, data=mpg, fill=drv)
#qplot(log(eno), data=maacs, fill=mopos)  # histogram by group

## Facets
qplot(displ, hwy, data=mpg, facets=.~drv)
qplot(hwy, data=mpg, facets=drv~., binwidth=2)

# ---- Basic Components ----
#
# Basic components of a ggplot2 plot:
#    - A data frame
#    - aesthetic mappings
#    - geoms (points, lines, shapes)
#    - facets for conditional plots
#    - stats (statistical transformations like binning, quantiles, smoothing)
#    - scales (eg male=red; female=blue) for aesthetic mapping
#    - coordinate system
#
# Plots are built in layers -- like an artists palette.
#

