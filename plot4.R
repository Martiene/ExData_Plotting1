
library(dplyr)
library(lubridate)

# download and unzip file 

url_hpc <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url_hpc, dest="hpc_dataset.zip", mode="wb") 
unzip ("hpc_dataset.zip")

# read file 

hpc <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?") 

head(hpc)

# transform Date variable and filter the dates 2007-02-01 and 2007-02-02

hpc$Date <- dmy(hpc$Date)

class(hpc$Date)

Date1<-as.Date("2007-02-01")
Date2<-as.Date("2007-02-02")

hpc_subset <- filter(hpc, between(Date, as.Date("2007-02-01"), as.Date("2007-02-02")))

# Create column in table with date and time merged together

class(hpc$Time)
hpc$Time <- hms(hpc$Time)

TimeDate <- strptime(paste(hpc_subset$Date, hpc_subset$Time), "%Y-%m-%d %H:%M:%S")

class(TimeDate)
head(TimeDate)

hpc_subset <- cbind(hpc_subset, TimeDate)

head(hpc_subset)

# make png plot4

png(filename = "plot4.png",
    height = 480,
    width = 480)

# plot 4: 4 graphs

par(mfrow = c(2,2))

## graph 1: 

plot(hpc_subset$TimeDate, hpc_subset$Global_active_power, 
     type= "l", 
     xlab = "", 
     ylab = "Global Active Power")

## graph 2: 

plot(hpc_subset$TimeDate, hpc_subset$Voltage, 
     type= "l", 
     xlab = "datetime", 
     ylab = "Voltage")

## graph 3: 

plot(hpc_subset$TimeDate, hpc_subset$Sub_metering_1, 
     type= "l", 
     xlab = "", 
     ylab = "Energy sub metering", 
     col = "black")
lines(hpc_subset$TimeDate, hpc_subset$Sub_metering_2, col = "red")
lines(hpc_subset$TimeDate, hpc_subset$Sub_metering_3, col = "blue")

legend("topright", 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"),
       border = "black",
       lty = 1)

## graph 4:

plot(hpc_subset$TimeDate, hpc_subset$Global_reactive_power, 
     type= "l",
     xlab = "datetime", 
     ylab = "Global_reactive_power")

# close connection

dev.off()