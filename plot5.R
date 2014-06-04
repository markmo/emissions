library(plyr)

# read the emissions data and Source Classification Code Table from the current directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# narrow the emissions data to Baltimore City, Maryland
baltimore <- NEI[NEI$fips == "24510", ]

# join the Baltimore emissions subset and Source Classification Code Table on the SCC column
merged <- merge(baltimore, SCC)

# filter sources by:
# SCC.Level.One = "Mobile Sources"
# SCC.Level.Two that includes the term "highway" or "LPG" in the name
# but doesn't include "equipment" in the SCC.Level.Three name
mobile.sources <- merged[merged$SCC.Level.One == "Mobile Sources", ]
motor.vehicle.sources <- mobile.sources[grepl("(highway|LPG)", mobile.sources$SCC.Level.Two, ignore.case=T, perl=T), ]
motor.vehicle.sources <- motor.vehicle.sources[!grepl("equipment", motor.vehicle.sources$SCC.Level.Three, ignore.case=T, perl=T), ]

# aggregate total emissions from motor vehicle sources in Baltimore by year
total.emissions.by.year <- ddply(motor.vehicle.sources, .(year), summarize, total.emissions=sum(Emissions))

# output the plot to a PNG file
png(file="plot5.png")

# plot a line chart of the summary data
plot(total.emissions.by.year, type="l", main="Emissions from motor vehicle sources in Baltimore City")

dev.off()

# Emissions from motor vehicle sources in Baltimore City have decreased
# from 1999 to 2008.