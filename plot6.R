library(plyr)
library(ggplot2)

# read the emissions data and Source Classification Code Table from the current directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# narrow the emissions data to Baltimore City and Los Angeles Counties
sub <- NEI[NEI$fips %in% c("24510", "06037"), ]

# join the emissions subset and Source Classification Code Table on the SCC column
merged <- merge(sub, SCC)

# filter sources by:
# SCC.Level.One = "Mobile Sources"
# SCC.Level.Two that includes the term "highway" or "LPG" in the name
# but doesn't include "equipment" in the SCC.Level.Three name
mobile.sources <- merged[merged$SCC.Level.One == "Mobile Sources", ]
motor.vehicle.sources <- mobile.sources[grepl("(highway|LPG)", mobile.sources$SCC.Level.Two, ignore.case=T, perl=T), ]
motor.vehicle.sources <- motor.vehicle.sources[!grepl("equipment", motor.vehicle.sources$SCC.Level.Three, ignore.case=T, perl=T), ]

# add a factor column for the county name
locations <- c("Baltimore City"="24510", "Los Angeles County"="06037")
ind <- match(motor.vehicle.sources$fips, locations)
motor.vehicle.sources$location <- as.factor(names(locations)[ind])

# aggregate total emissions from motor vehicle sources by year and county
summary <- ddply(motor.vehicle.sources, .(year, location), summarize, total.emissions=sum(Emissions))

# output the plot to a PNG file
png(file="plot6.png")

# plot a multi-panel line chart of the summary data by county
# include the linear regression line to show overall trend
ggplot(summary, aes(year, total.emissions)) +
  geom_line() +
  facet_grid(. ~ location) +
  geom_smooth(method="lm") +
  labs(title="Emissions from motor vehicle sources")

dev.off()

# Los Angeles County has seen greater changes over time in motor vehicle emissions.
# While the net change from 1999 to 2008 in LA County has been less, the volatility
# over the years has been greater.
