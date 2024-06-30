# Define UI
ui <- fluidPage(
  theme = shinytheme("united"),  # Enhanced visual appearance with a Bootstrap theme
  
  titlePanel(h1("Wolverhampton Weather Prediction", icon("wind")),
             windowTitle = "Weather Prediction with Decision Tree"),
  
  sidebarLayout(
    sidebarPanel(
      tags$h3("Weather Prediction Tool"),
      tags$p("Select a date to predict the wind speed in Wolverhampton."),
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
                   "Predict Wind Speed",
                   icon = icon("wind"),
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
  initialText <- "Please select a date and click 'Predict' to see the wind speed prediction."
  
  output$prediction <- renderText({
    if (!is.null(input$predict) && input$predict > 0) {
      sprintf("The predicted wind speed for %s using %s model is %s km/h.", 
              as.character(input$date), 
              input$model,
              round(runif(1, 0, 20), 1))  # Simulating a wind speed prediction
    } else {
      initialText
    }
  })
  
  observeEvent(input$predict, {
    output$prediction <- renderText({
      sprintf("The predicted wind speed for %s using %s model is %s km/h.", 
              as.character(input$date), 
              input$model,
              round(runif(1, 0, 20), 1))  # Simulating a wind speed prediction
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)