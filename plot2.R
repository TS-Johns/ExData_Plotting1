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

plotFileName <- "plot2.png"

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


## ----------------------------------- Step 03: Init Graphic Device -----------------------------------
png(plotFileName, width=480, height=480) #Create PNG with desired height & width (not 480x480 is default so did not need to specify)


## ----------------------------------- Step 04: Generate Plot -----------------------------------
plot(plotData$DateTime, plotData$Global_active_power, type="l", 
     main="",xlab="", ylab="Global Active Power (kilowatts)", xaxt="n")
# Options used are lines (default black color)
#     blank title, overridding default x/y-label
#     xact = "n" to force hiding of x-labels

# Note - x labels seemd to autodisplay to correct value
# However following code can be used to see any desired adte/time format
axis.POSIXct(1, plotData$DateTime, format="%a")


## ----------------------------------- Step 05: Clean-Up -----------------------------------
dev.off()   #close active graphic device pointing to png file

