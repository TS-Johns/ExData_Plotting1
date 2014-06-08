## Author:  TS Johns
## Date:    2014-06-08
## About:   This is R script for Course Project 1, for the Exploratory Data Analysis course (part of John Hopkins - Data science Track)
##          This script does not contain functions, but just a series of commands to create desired plot
##          This script usues the base plotting package, as well as generating output in PNG file
## Credits: This package was produced as a clone of the repo https://github.com/rdpeng/ExData_Plotting1

## ----------------------------------- Step 01: Set Variables -----------------------------------
dataFilePathName <- "../Data/household_power_consumption.txt"
# Note: Date oiginally read in as character in d/m/yyyy format, using that format to isolate desired data
dateStart <- "1/2/2007"
dateEnd <- "2/2/2007"

plotFileName <- "plot4.png"

## ----------------------------------- Step 02: Load & Get Data to Plot -----------------------------------

baseData <- read.table(dataFilePathName, header = TRUE, sep=";", 
                       na.strings="?", stringsAsFactors=FALSE, check.names=FALSE)
#Note - Make sue to handle NAs appropriately since encoded as ? in file

plotData <- baseData[baseData$Date == dateStart | baseData$Date == dateEnd,]   #Limit to desired dates - using OR and character equality not date ranges, since we only need data for 2 dates

# Remove larger table from memory
remove(baseData)

# Format columns within plotData since many initially read in as numeric
plotData$Global_active_power <- as.numeric(plotData$Global_active_power)
plotData$Global_reactive_power <- as.numeric(plotData$Global_reactive_power)
plotData$Global_intensity <- as.numeric(plotData$Global_intensity)
plotData$Voltage <- as.numeric(plotData$Voltage)
plotData$Sub_metering_1 <- as.numeric(plotData$Sub_metering_1)
plotData$Sub_metering_2 <- as.numeric(plotData$Sub_metering_2)
plotData$Sub_metering_3 <- as.numeric(plotData$Sub_metering_3)

# Next handle date columns as well
plotData$Orig_date <- plotData$Date
plotData$Date <- as.Date(plotData$Date, format = "%d/%m/%Y")
plotData$DateTime <- as.POSIXct(paste(as.character(plotData$Date), plotData$Time, sep=" "))


## ----------------------------------- Step 03: Init Graphic Device  & Layout-----------------------------------
png(plotFileName, width=480, height=480) #Create PNG with desired height & width (not 480x480 is default so did not need to specify)

par(mfrow=c(2,2), margin=c(3, 3, 0, 0)) #2x2 display fill row first


## ----------------------------------- Step 04-C: Generate SubPlots 1 & 2-----------------------------------
plot(plotData$DateTime, plotData$Global_active_power, type="l", 
     main="",xlab="", ylab="Global Active Power")
# Options used are lines (default black color)
#     blank title, overridding default x/y-label
#Note: To make code easier for multiple plot example: using default display of datetime as %a
#     Plus mimicing desired result so no xlabel

plot(plotData$DateTime, plotData$Voltage, type="l", 
     main="",xlab="datetime", ylab="Voltage" )
# Options used are lines (default black color)
#     blank title, overridding default x/y-label
#     Plus set y range limits
#Note: To make code easier for multiple plot example: using default dispaly of datetime as %a

## ----------------------------------- Step 04-C: Generate Sub-Multi Plot 3-----------------------------------
## In this example we will be sharing same plot for 3 graphs
## To do so, need to set y-range fixed for each graph, so compute min/max
ymin <- min(plotData$Sub_metering_1, plotData$Sub_metering_2, plotData$Sub_metering_3)
ymax <- max(plotData$Sub_metering_1, plotData$Sub_metering_2, plotData$Sub_metering_3)

plot(plotData$DateTime, plotData$Sub_metering_1, type="l", 
     main="",xlab="", ylab="Energy sub metering", ylim=c(ymin, ymax))
# Options used are lines (default black color)
#     blank title, overridding default x/y-label
#     Plus set y range limits
#Note: To make code easier for multiple plot example: using default dispaly of datetime as %a


# Next we need to add additional plots - use par to suspend redrwaing plot
par(new=TRUE)
plot(plotData$Sub_metering_2, type="l", col="red",
     main="",xlab="", ylab="",  ylim=c(ymin, ymax), xaxt="n", yaxt="n")

par(new=TRUE)
plot(plotData$Sub_metering_3, type="l", col="blue",
     main="",xlab="", ylab="",  ylim=c(ymin, ymax), xaxt="n", yaxt="n")

#set back to standrad value of false
par(new=FALSE)

legend("topright", 
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       col=c("black","red","blue"), lwd=1, bty="n")
#Note: need to include lwd since lines
#     Also using bty ="n" to hide legend box

## ----------------------------------- Step 04-C: Generate Final SubPlot-----------------------------------
plot(plotData$DateTime, plotData$Global_reactive_power, type="l", 
     main="",xlab="datetime", ylab="Global_reactive_power")
# Options used are lines (default black color)
#     blank title, overridding default x/y-label
#Note: To make code easier for multiple plot example: using default dispaly of datetime as %a


## ----------------------------------- Step 05: Clean-Up -----------------------------------
dev.off()   #close active graphic device pointing to png file

