library(plyr)

# read the emissions data from the current directory
NEI <- readRDS("summarySCC_PM25.rds")

# narrow the emissions data to Baltimore City, Maryland
baltimore <- NEI[NEI$fips == "24510", ]

# aggregate total emissions from all sources in Baltimore by year
total.emissions.by.year <- ddply(baltimore, .(year), summarize, total.emissions=sum(Emissions))

# output the plot to a PNG file
png(file="plot2.png")

# plot a line chart of the summary data
plot(total.emissions.by.year, type="l", main="Emissions from PM[2.5] in Baltimore City, Maryland")

dev.off()

# Total emissions from PM[2.5] have decreased overall in Baltimore City, Maryland
# from 1999 to 2008. (There was a short-term upswing from 2002 to 2005, but the
# number declined overall during the reported time period.)