# Load data
setwd("~/Dropbox (Personal)/Study/Data Science/datasciencecoursera/Exploratory Data Analysis/week2")
if ( !exists("NEI") || !exists("SCC")) {
  NEI <- readRDS("data/summarySCC_PM25.rds")
  SCC <- readRDS("data/Source_Classification_Code.rds")
}

# NEI contains PM2.5 emissions for 1999 - 2008 (every 3 years). 
#   fips:   A five-digit number (represented as a string) indicating the U.S. county
#   SCC:    The name of the source as indicated by a digit string (see source code 
#           classification table)
#   Pollutant: A string indicating the pollutant
#   Emissions: Amount of PM2.5 emitted, in tons
#   type:   The type of source (point, non-point, on-road, or non-road)
#   year:   The year of emissions recorded
#
# SCC contains a mapping from the SCC digit strings in the Emissions table to the 
# actual name of the PM2.5 source. 

# Question 1: Have total emissions from PM2.5 decreased in the United States from 
# 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# Calculate the total for each year.
# Useful: http://davetang.org/muse/2013/05/22/using-aggregate-and-apply-in-r/
years <- unique(NEI$year)
if ( !exists("pm25_by_year")) {
  pm25_by_year <- aggregate(NEI$Emissions, by=list(years), FUN=sum, na.rm=TRUE)
  names(pm25_by_year) <- c("year", "total_pm25")
}

with(pm25_by_year, plot(year, total_pm25, pch=20, col="blue", type="l",
                        ylab="Total Emissions Pm2.5 in tons"))
fit <- lm(total_pm25 ~ year, pm25_by_year)
abline(fit,col="red")
title("PM2.5 Emissions by Year")


# Question 2: Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system 
# to make a plot answering this question.

# Calculate total for just fips 24510
if ( !exists("pm25_by_year_baltimore")) {
  baltimore_pm25 <- NEI[NEI$fips=="24510",]
  pm25_by_year_baltimore <- aggregate(baltimore_pm25$Emissions, by=list(baltimore_pm25$year), FUN=sum)
  names(pm25_by_year_baltimore) <- c("year", "total_pm25")
}

with(pm25_by_year_baltimore, plot(year, total_pm25, pch=20, col="blue", type="l",
                                  ylab="Total Emissions Pm2.5 in tons"))
fit <- lm(total_pm25 ~ year, pm25_by_year_baltimore)
abline(fit,col="red")
title("PM2.5 Emissions by Year for Baltimore, Maryland")


# Question 3: Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable, which of these four sources 
# have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? Use the ggplot2 
# plotting system to make a plot answer this question.

library(ggplot2)
baltimore_sources <- aggregate(baltimore_pm25$Emissions, by=list(baltimore_pm25$year, baltimore_pm25$type), FUN=sum)
names(baltimore_sources) <- c("year", "type", "emissions")
g <- ggplot(data=baltimore_sources, aes(year, emissions))
g <- g + geom_point() + geom_line() + facet_grid(. ~ type)
print(g)


# Question 4: Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999–2008?

# Question 5: How have emissions from motor vehicle sources changed from 
# 1999–2008 in Baltimore City?

# Question 6: Compare emissions from motor vehicle sources in Baltimore City 
# with emissions from motor vehicle sources in Los Angeles County, California 
# (fips == "06037"). Which city has seen greater changes over time in motor 
# vehicle emissions?
