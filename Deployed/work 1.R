library(shiny)
library(shinythemes)
library(zoo)
library(caret)  # For model training and prediction
library(forecast)  # For ARIMA model
library(e1071)  # For SVR model

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
  roll_mean <- zoo::rollmean(data, k = window_size, fill = NA, align = "right")
  return(roll_mean)
}

# Preprocess data function
preprocess_data <- function(data) {
  required_columns <- c("datetime", "temp", "tempmin", "tempmax", "feelslike", "feelslikemin", "feelslikemax", "precip")
  
  # Check if all required columns are present
  missing_columns <- setdiff(required_columns, colnames(data))
  if (length(missing_columns) > 0) {
    stop(paste("The following required columns are missing from the data:", paste(missing_columns, collapse = ", ")))
  }
  
  # Convert temperature columns to Celsius
  temp_columns <- c("temp", "tempmin", "tempmax", "feelslike", "feelslikemin", "feelslikemax")
  data[, temp_columns] <- lapply(data[, temp_columns], fahrenheit_to_celsius)
  
  # Calculate rolling average for temperature
  data$rolling_temp_avg <- calculate_rolling_average(data$temp, window_size = 7)
  
  # Handle missing values by imputing with the mean (alternative: use other imputation methods)
  data[is.na(data)] <- mean(data, na.rm = TRUE)
  
  # Keep only required columns
  data <- data[, required_columns]
  data <- data[complete.cases(data),]
  data$datetime <- as.Date(data$datetime)
  
  return(data)
}

# Define functions for rolling computations
pct_diff <- function(old, new) {
  return ((new - old) / old)
}

compute_rolling <- function(data, horizon, col) {
  label <- paste("rolling", horizon, col, sep = "_")
  data[[label]] <- zoo::rollmean(data[[col]], k = horizon, fill = NA)
  data[[paste0(label, "_pct")]] <- pct_diff(data[[label]], data[[col]])
  return(data)
}

# Load and preprocess data
data <- get_weather_data()
data <- preprocess_data(data)

# Update data with rolling computations
rolling_horizons <- c(3, 14)
for (horizon in rolling_horizons) {
  for (col in c("tempmax", "tempmin", "precip", "temp")) {
    data <- compute_rolling(data, horizon, col)
  }
}

# Remove rows with missing values
data <- data[complete.cases(data),]

# Split data into training and testing sets
train_data <- data[data$datetime <= as.Date("2022-01-01"), ]
test_data <- data[data$datetime > as.Date("2022-01-01"), ]

# Ensure there are no missing values in train_data
train_data <- train_data[complete.cases(train_data), ]

# Train models
model_lm <- train(temp ~ ., data = train_data, method = "lm", na.action = na.omit)
model_tree <- train(temp ~ ., data = train_data, method = "rpart", na.action = na.omit)
model_rf <- train(temp ~ ., data = train_data, method = "rf", na.action = na.omit)
model_svr <- train(temp ~ ., data = train_data, method = "svmRadial", na.action = na.omit)
model_arima <- auto.arima(train_data$temp, na.action = na.omit)
model_ridge <- train(temp ~ ., data = train_data, method = "ridge", na.action = na.omit)

# Define UI
ui <- fluidPage(
  theme = shinytheme("united"),  # Enhanced visual appearance with a Bootstrap theme
  
  titlePanel(h1("Wolverhampton Weather Prediction", icon("thermometer-half")),
             windowTitle = "Weather Prediction with Decision Tree"),
  
  sidebarLayout(
    sidebarPanel(
      tags$h3("Weather Prediction Tool"),
      tags$p("Select a date to predict the temperature in Wolverhampton."),
      dateInput("date", 
                label = "Choose a date:", 
                value = Sys.Date(),
                min = Sys.Date() - 30, 
                max = Sys.Date() + 30),
      br(),
      selectInput("model",
                  label = "Select Model:",
                  choices = c("Linear Regression", "Decision Tree", "Random Forest", "SVR", "ARIMA", "Ridge Regression")),
      br(),
      actionButton("predict", 
                   "Predict Temperature",
                   icon = icon("thermometer-half"),
                   class = "btn-success"),
      tags$hr(),
      tags$p("Developed using Decision Tree model."),
      tags$img(src = "weather_icon.png", height = 60, style = "opacity: 0.8")
    ),
    mainPanel(
      tags$div(style = "background-color: #ebf5fb; padding: 20px; border-radius: 10px;",
               tags$h4("Prediction:"),
               textOutput("prediction")
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  initialText <- "Please select a date and click 'Predict' to see the temperature prediction."
  
  output$prediction <- renderText({
    if (!is.null(input$predict) && input$predict > 0) {
      # Prepare input data for prediction (this should match the model's expected input)
      input_date <- as.Date(input$date)
      input_data <- test_data[test_data$datetime == input_date, ]
      
      # Ensure input_data is not empty
      if (nrow(input_data) == 0) {
        return("No data available for the selected date.")
      }
      
      # Select the model and predict
      model <- switch(input$model,
                      "Linear Regression" = model_lm,
                      "Decision Tree" = model_tree,
                      "Random Forest" = model_rf,
                      "SVR" = model_svr,
                      "ARIMA" = model_arima,
                      "Ridge Regression" = model_ridge)
      
      if (input$model == "ARIMA") {
        prediction <- forecast::forecast(model, h = 1)$mean
      } else {
        prediction <- predict(model, newdata = input_data)
      }
      
      sprintf("The predicted temperature for %s using %s model is %.2f °C.", 
              as.character(input$date), 
              input$model,
              round(prediction, 2))
    } else {
      initialText
    }
  })
  
  observeEvent(input$predict, {
    output$prediction <- renderText({
      if (!is.null(input$predict) && input$predict > 0) {
        # Prepare input data for prediction (this should match the model's expected input)
        input_date <- as.Date(input$date)
        input_data <- test_data[test_data$datetime == input_date, ]
        
        # Ensure input_data is not empty
        if (nrow(input_data) == 0) {
          return("No data available for the selected date.")
        }
        
        # Select the model and predict
        model <- switch(input$model,
                        "Linear Regression" = model_lm,
                        "Decision Tree" = model_tree,
                        "Random Forest" = model_rf,
                        "SVR" = model_svr,
                        "ARIMA" = model_arima,
                        "Ridge Regression" = model_ridge)
        
        if (input$model == "ARIMA") {
          prediction <- forecast::forecast(model, h = 1)$mean
        } else {
          prediction <- predict(model, newdata = input_data)
        }
        
        sprintf("The predicted temperature for %s using %s model is %.2f °C.", 
                as.character(input$date), 
                input$model,
                round(prediction, 2))
      } else {
        initialText
      }
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
