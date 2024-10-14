# Load required libraries
library(renv) # For managing project-specific R environment
library(DBI) # For database connectivity
library(lubridate) # For date-time manipulation
library(hms) # For working with time data
library(summarytools) # For creating summary tables
library(dplyr) # For data manipulation and piping

# Load additional libraries
library(xts) # For working with time series data
library(ggplot2) # For data visualization
library(forecast) # For time series forecasting

# Uncomment the line below to sourc the data wrangling script
#source("src/data_wrangling.R")

# Uncomment the line below to source the EDA script
# source("src/eda.R")

# Source the ARIMA model script
source("src/model_arima.R")

# Source the model evaluation script
source("src/evaluation.R")