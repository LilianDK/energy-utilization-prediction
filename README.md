# Electric Demand Forecasting

This project focuses on forecasting electric demand using historical data. The code provided performs data preprocessing, model development, and visualization to analyze and predict electric demand patterns.

## Table of Contents
- [Data Preprocessing](#data-preprocessing)
- [Model Development](#model-development)
- [Visualization](#visualization)

## Data Preprocessing
The data is preprocessed to create separate training and test datasets based on a specific date threshold. The 'a_sum' column is converted into a time series with a daily frequency. Additionally, the demand is aggregated by the day of the year, and a smooth curve is computed to visualize the data.

## Model Development
An ARIMA (Auto-Regressive Integrated Moving Average) model is fitted to the time series data. The model is trained on the training data and then used to make predictions on the test data. The model is updated iteratively as new data points are introduced, allowing for dynamic forecasting.

## Visualization
The project includes several visualizations to understand the data and evaluate the model's performance:
- **Average Daily Demand:** A plot showing the average daily demand over time, along with a smooth curve to highlight the overall trend.
- **Forecast Error:** A plot visualizing the error in the forecast, providing insights into the model's accuracy.
- **Real vs. Forecast:** A comparison plot displaying the actual demand values against the forecasted values, helping to assess the model's predictive power.

## Getting Started
To run the code and reproduce the results, follow these steps:
1. Ensure you have the necessary R packages installed.
2. Load the required packages at the beginning of your R script.
3. Replace the placeholder code with your actual data and adjust the model parameters as needed.
4. Execute the code to generate the visualizations and analyze the electric demand forecasting.

## Licensing
Data Provenance: Open Power System Data. 2020. Data Package Time series. Version 2020-10-06. https://doi.org/10.25832/time_series/2020-10-06
Data Licence: MIT Licensing, https://nbviewer.org/github/Open-Power-System-Data/datapackage_timeseries/blob/2020-10-06/main.ipynb