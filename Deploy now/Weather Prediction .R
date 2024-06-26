
library(shiny)
library(shinythemes)

# Function to read weather data from a CSV file
get_weather_data <- function() {
  file_path <- "C:/Users/Uche Buzz/Documents/Deployment/weatherdata.csv"
  data <- read.csv(file_path)
  return(data)
}

# Function to convert Fahrenheit to Celsius
fahrenheit_to_celsius <- function(f) {
  (f - 32) * 5 / 9
}

# Function to calculate rolling average
calculate_rolling_average <- function(data, window_size) {
  roll_mean <- zoo::rollapplyr(data, width = window_size, FUN = mean, fill = NA, align = "right")
  return(roll_mean)
}

# Preprocess data function
preprocess_data <- function(data) {
  required_columns <- c("datetime", "temp", "tempmin", "tempmax", "feelslike", "feelslikemin", "feelslikemax", "precip", "dew")}
  
  # Check if all required columns are present
  missing_columns <- setdiff(required_columns, colnames(data))
  if (length(missing_columns) > 0) {
    stop(paste("The following required columns are missing from the data:", paste(missing_columns, collapse = ", ")))
  }
  
  # Convert temperature columns to Celsius
  temp_columns <- c("temp", "tempmin", "tempmax", "feelslike", "feelslikemin", "feellikemax")
  data[, temp_columns] <- lapply(data[, temp_columns], fahrenheit_to_celsius)
  
  # Calculate rolling average for temperature
  data$rolling_temp_avg <- calculate_rolling_average(data$temp, window_size = 7)  # Example window size of 7 days
  
  # Keep only required columns
  data <- data[, required_columns]
  data <- data[complete.cases(data),]
  data$datetime <- as.Date(data$datetime)
  
  return(data)


# Define functions for rolling computations
pct_diff <- function(old, new) {
  return ((new - old) / old)
}

compute_rolling <- function(data, horizon, col) {
  label <- paste("rolling", horizon, col, sep = "_")
  data[label] <- zoo::rollmean(data[[col]], k = horizon, fill = NA)
  data[paste0(label, "_pct")] <- pct_diff(data[label], data[[col]])
  return(data)
}

# Update data with rolling computations
rolling_horizons <- c(3, 14)

for (horizon in rolling_horizons) {
  for (col in c("tempmax", "tempmin")) {
    data <- compute_rolling(data, horizon, col) # Assuming 'data' is your dataframe
  }
}

