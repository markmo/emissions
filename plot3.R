library(plyr)
library(ggplot2)

# read the emissions data from the current directory
NEI <- readRDS("summarySCC_PM25.rds")

# narrow the emissions data to Baltimore City, Maryland
baltimore <- NEI[NEI$fips == "24510", ]

# aggregate total emissions in Baltimore by year and source type
summary <- ddply(baltimore, .(year, type), summarize, total.emissions=sum(Emissions))

# output the plot to a PNG file
png(file="plot3.png", width=600)

# plot a multi-panel line chart of the summary data by source type
# include the linear regression line to show overall trend
ggplot(summary, aes(year, total.emissions)) +
  geom_line() +
  facet_grid(. ~ type) +
  geom_smooth(method="lm") +
  labs(title="Emissions from PM[2.5] in Baltimore City, Maryland")

dev.off()

# The sources: non-road, nonpoint, and on-road have seen decreases in emissions
# from 1999 to 2008 in Baltimore City, Maryland.
# Only the point source has increased overall due to an increase in emissions from 1999 to 2005.