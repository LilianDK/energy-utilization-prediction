# Exploratory Data Analysis (EDA)
# --------------------------------------------------------------------------
# Redirect the output of the summary function to a text file
sink("output/eda.txt")
# Print the summary statistics of the data frame
print(summary(df))
# Stop redirecting the output
sink()

# Create an xts (extended time series) object for the demand time series
demandts <- xts(df$a_sum, df$date)
# Save a plot of the mean energy demand evolution to a PNG file
png(filename="output/eda_descriptive.png", width = 2000, height = 600)
plot(demandts, main = 'Mean energy demand evolution, Germany', xlab = 'Date', ylab = 'Demand (GWh)')
# Close the PNG file
dev.off()