library(shiny)
library(shinythemes)
library(rpart)
library(lubridate)

# Load dataset
data <- read.csv('C:/Users/Uche Buzz/Documents/Deployment/2020_2021.csv')
data$datetime <- as.Date(data$datetime, "%Y-%m-%d")

# Feature engineering
data$month <- month(data$datetime)
data$day <- day(data$datetime)
data$year <- year(data$datetime)

data

# Split the data
set.seed(42)  # For reproducibility
train_indices <- sample(1:nrow(data), 0.8 * nrow(data))
train <- data[train_indices, ]
test <- data[-train_indices, ]

# Train the model using rpart (decision tree)
model <- rpart(tempmax ~ ., data = train)



