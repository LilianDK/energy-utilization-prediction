# Create test and train data
#--------------------------------------------------
# Subset the data to create test and train datasets based on the 'date' column
df <- load(file='data/processed/data_transformed.rda')
df_test <- subset(df, date >= strptime('01-01-2019', format = '%d-%m-%Y'))
df <- subset(df, date < strptime('01-01-2019', format = '%d-%m-%Y'))

# Convert the 'a_sum' column to a time series with a frequency of 1 (daily)
ts <- ts(df$a_sum, frequency = 1)

# Aggregating demand by day of the year (average)
avg_demand_per_yearday <- aggregate(a_sum ~ date, df, FUN = mean)

# Computing the smooth curve for the time series
# Replicate the data to ensure continuity when computing the smooth curve
smooth_yearday <- rbind(avg_demand_per_yearday, avg_demand_per_yearday, avg_demand_per_yearday, avg_demand_per_yearday, avg_demand_per_yearday)
# Use LOWESS (Locally Weighted Scatterplot Smoothing) to compute the smooth curve
smooth_yearday <- lowess(smooth_yearday$a_sum, f = 1 / 45)
# Extract the smoothed values for plotting
l <- length(avg_demand_per_yearday$a_sum)
l0 <- 2 * l + 1
l1 <- 3 * l
smooth_yearday <- smooth_yearday$y[l0:l1]

# Plotting the average daily demand and the smooth curve
par(mfrow = c(1, 1))
dates <- df$date
png(filename="output/eda_avg_load_actual_daily.png", width = 2000, height = 600)
plot(dates, avg_demand_per_yearday$a_sum, type = 'l', main = 'Average daily demand', xlab = 'Date', ylab = 'Demand (GWh)')
lines(dates, smooth_yearday, col = 'blue', lwd = 2)
dev.off()

# Model development
#------------------------------------------------------------
# Fit an ARIMA model to the time series data
model <- Arima(ts, order = c(2, 1, 2), seasonal = list(order = c(1, 1, 1), period = 7))

# Initialize variables for error calculation and predictions
auxts <- ts
auxmodel <- model
errs <- c()
pred <- c()
perc <- c()

# Loop through the test data to make predictions and calculate errors
for (i in 1:nrow(df_test)) {
  # Make a one-step-ahead prediction using the current model
  p <- as.numeric(predict(auxmodel, newdata = auxts, n.ahead = 1)$pred)
  # Append the prediction to the 'pred' vector
  pred <- c(pred, p)
  # Calculate the error as the difference between the prediction and the actual value
  errs <- c(errs, p - df_test$a_sum[i])
  # Calculate the percentage error
  perc <- c(perc, (p - df_test$a_sum[i]) / df_test$a_sum[i])
  # Update the time series with the new data point
  auxts <- ts(c(auxts, df_test$a_sum[i]), frequency = 7)
  # Update the model with the new data point
  auxmodel <- Arima(auxts, model = auxmodel)
}

# Plot the forecast error
par(mfrow = c(1, 1))
png(filename="output/prediction_forecast_error.png", width = 2000, height = 600)
plot(errs, type = 'l', main = 'Error in the forecast')
dev.off()

# Plot the real vs. forecast values
png(filename="output/prediction_real_vs_forecast.png", width = 2000, height = 600)
plot(pred, type = 'l', main = 'Real vs. forecast', col = 'red')
lines(df_test$a_sum)
legend('topright', c('Real', 'Forecast'), lty = 1, col = c('black', 'red'))
dev.off()