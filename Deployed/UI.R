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
                  choices = c("Linear Regression", "Decision Tree", "Random Forest", "ARIMA", "Ridge Regression")),
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
                      #"ARIMA" = model_arima,
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


