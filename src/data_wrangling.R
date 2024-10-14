# Load data
# --------------------------------------------------------------------
# Connect to the SQLite database
db2 <- dbConnect(RSQLite::SQLite(), "data/raw/time_series.sqlite")
# List the tables in the database
dbListTables(db2)

# Select total actual energy consumption data
# -------------------------------------------
# Retrieve data from the database
df <- dbGetQuery(db2, "SELECT * FROM time_series_60min_singleindex")

# Select specific columns containing actual energy consumption data
df_load_actuals <- df[,c("cet_cest_timestamp","AT_load_actual_entsoe_transparency","CH_load_actual_entsoe_transparency","DE_load_actual_entsoe_transparency","ES_load_actual_entsoe_transparency","IT_load_actual_entsoe_transparency","NL_load_actual_entsoe_transparency")]
# Save the selected data to a file for future use
save(df_load_actuals,file="data/processed/data_snapshot.Rda")

# Transform data
# --------------
# Initialize an empty data frame to store the transformed data
df <- ""
df <- data.frame(datetime=as.Date(character()),
                 date=as.Date(character()),
                 time=as.Date(character()),
                 country=character(), 
                 load_actual=numeric(), 
                 stringsAsFactors=TRUE) 

# Get the number of columns in the original data
columns <- ncol(df_load_actuals)

# Create a data frame to store datetime information
df_datetime <- data.frame(
  date_time = df_load_actuals[,1]
)

# Transform the datetime column into a more usable format
df2 <- ""
df2 <- df_datetime |> 
  mutate(
    date_time = lubridate::ymd_hms(date_time),
    date = lubridate::date(date_time),
    time = hms::as_hms(date_time),
    year = year(date_time)
  )

# Convert the 'date' column to a factor with day names
df2$day <- as.factor(strftime(df2$date, format = '%A'))
# Convert the 'date' column to a factor with year and day information
df2$yearday <- as.factor(strftime(df2$date, format = '%m%d'))

# Loop through each column of actual energy consumption data
for (x in 2:columns) {
  # Create a subset of the data for each country
  subset <- df2
  load_actual <- df_load_actuals[x]
  str <- colnames(df_load_actuals[x])
  # Extract the country code from the column name
  subset$country <- substr(str, 1, 2)
  # Add the actual energy consumption values to the subset
  subset$load_actual <- df_load_actuals[,c(x)]
  
  # Bind the subset to the main data frame
  df <- rbind(df, subset)
}

# Group the data by date, year, day, yearday, and country, and calculate the sum of load_actual
df <- df %>%
  group_by(date, year, day, yearday, country) %>%
  summarise(a_sum=sum(load_actual))

# Filter the data to keep only the records for Germany (DE)
df <- df[df$country == "DE",]
# Remove any rows with missing values
df <- na.omit(df)
# Save the transformed data to a file
save(df,file="data/processed/data_transformed.Rda")