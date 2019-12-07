# =============================================================================
# Week 1 Assignment - Plot 2
# =============================================================================
# Source: UC Irvine Machine Learning Repository, 
# “Individual household electric power consumption Data Set”.

# Version: R version 3.6.1, Mac OS 10.13.3.

# Download and unzip file in R
if (!file.exists("data")) {dir.create("data")}
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "./data/household_power_consumption.zip", mode = "wb")
unzip("./data/household_power_consumption.zip", exdir = "./data/")

# Load dataset:
power <- read.table("./data/household_power_consumption.txt", header = TRUE, 
                    sep = ";", colClasses = "character")

# Combining Date and Time variables:
library(dplyr)
power <- mutate(power, Time2 = paste(Date, Time)) 

# Reformat the new time variable:
power <- mutate(power, Time3 = as.POSIXct(strptime(Time2, format = "%d/%m/%Y %H:%M:%S", tz = "CET")))
# Time zone have to be added. Since the data was collected in Paris, CET was used.
# POSIXct may be optional

# Convert dates to weekdays:
power <- mutate(power, Weekday = weekdays(Time3))

# Subset dataset to keep only desired dates and variables. 
x <- strptime("2007-02-01", format = "%Y-%m-%d", tz = "CET")
y <- strptime("2007-02-03", format = "%Y-%m-%d", tz = "CET")
power2 <- subset(power, Time3 >= x & Time3 < y, 
                 select = c(Time3, Weekday, Global_active_power:Sub_metering_3))

# Convert variables of interest from factor to numeric
power2[3:9] <- mutate_if(power2[3:9], is.character, as.numeric)

# Plot 2 ----------------------------------------------------------------
par(mfrow = c(1, 1))
with(power2, plot(Time3, Global_active_power, type = "l", main = "",
                  xlab = "", ylab = "Global Active Power (kilowatts)"))
# It's a supirse that the x-axis is automatically labelled weekdays...
dev.copy(png, filename = "plot2.png", width = 480, height = 480, 
         units = "px", bg = "white")
dev.off()

