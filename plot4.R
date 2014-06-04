library(plyr)

# read the emissions data and Source Classification Code Table from the current directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# join the two files on the SCC column
merged <- merge(NEI, SCC)

# filter sources with a combination of "coal" and "comb", "fired", or "fuel"
# in the Short.Name column from the SCC data set. Examples include:
# Ext Comb /Industrial /Anthracite Coal /Pulverized Coal
# Sugar Beet Processing /Pulp Dryer : Coal-fired
# In-Process Fuel Use /Bituminous Coal /General
coal.sources <- merged[grepl("^(?=.*\\bcoal\\b)(?=.*\\b(comb|fired|fuel)).*$", merged$Short.Name, ignore.case=T, perl=T), ]

# aggregate total emissions from coal combustion-related sources across the United States by year
total.emissions.by.year <- ddply(coal.sources, .(year), summarize, total.emissions=sum(Emissions))

# output the plot to a PNG file
png(file="plot4.png")

# plot a line chart of the summary data
plot(total.emissions.by.year, type="l", main="Emissions from coal-combustion related sources in the US")

dev.off()

# Emissions from coal-combustion related sources in the US have decreased
# from 1999 to 2008.