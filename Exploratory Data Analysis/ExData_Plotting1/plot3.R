# Exploratory Data Analysis -- Week 1 Peer Assessment
#

# Some helper functions. Also sets current working directory.
source("helpers.R")

# Acquire the data, and read it into a BFDF
if ( !exists("data") ) {
    dataFile <- fetchData("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "./data/household_power_consumption")
    data <- loadData(dataFile)
}

# Plot
plotFile <- "plot3.png"
png(plotFile, width = 480, height = 480)
plot(data$Time, data$Sub_metering_1, ylab = "Energy sub metering", xlab = "", type = "n")
points(data$Time, data$Sub_metering_1, type = "l", col = "black")
points(data$Time, data$Sub_metering_2, type = "l", col = "red")
points(data$Time, data$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lwd = 1)

dev.off()
printf("%s created", plotFile)
