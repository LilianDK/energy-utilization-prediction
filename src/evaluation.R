# Model evaluation
# -------------------------------------------------------------
# Calculate the mean absolute error (MAE) of the forecast errors
abserr <- mean(abs(errs))
# Calculate the mean percentage error (MPE) of the forecast errors
percerr <- mean(abs(perc)) * 100

# Save a plot of the ARIMA model's forecast to a PNG file
png(filename="output/prediction_arima.png", width = 2000, height = 600)
# Plot the forecast of the ARIMA model
plot(forecast(Arima(tail(ts, 200), model = model)))
# Close the PNG file
dev.off()