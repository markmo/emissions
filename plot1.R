library(plyr)

# read the emissions data from the current directory
NEI <- readRDS("summarySCC_PM25.rds")

# aggregate total emissions from all sources across the United States by year
total.emissions.by.year <- ddply(NEI, .(year), summarize, total.emissions=sum(Emissions))

# output the plot to a PNG file
png(file="plot1.png")

# plot a line chart of the summary data
plot(total.emissions.by.year, type="l", main="Emissions from PM[2.5] in the US")

dev.off()

# Total emissions from PM[2.5] have decreased in the United States
# from 1999 to 2008.