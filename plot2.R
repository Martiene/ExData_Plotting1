
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

# make png plot2

png(filename = "plot2.png",
    height = 480,
    width = 480)

# plot 2: line chart 

plot(hpc_subset$TimeDate, hpc_subset$Global_active_power, 
    type= "l", 
    xlab = "", 
    ylab = "Global Active Power")

# close connection

dev.off()
