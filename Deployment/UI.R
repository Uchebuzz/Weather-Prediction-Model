library(shiny)
library(shinythemes)

# Define UI
ui <- fluidPage(
  theme = shinytheme("united"),  # Enhanced visual appearance with a Bootstrap theme
  
  titlePanel(h1("Wolverhampton Weather Prediction", icon("sun")),
             windowTitle = "Weather Prediction with Decision Tree"),
  
  sidebarLayout(
    sidebarPanel(
      tags$h3("Weather Prediction Tool"),
      tags$p("Select a date to predict the maximum temperature in Wolverhampton."),
      dateInput("date", 
                label = "Choose a date:", 
                value = Sys.Date(),
                min = Sys.Date() - 30, 
                max = Sys.Date() + 30),
      br(),
      actionButton("predict", 
                   "Predict Maximum Temperature",
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
      sprintf("The predicted max temperature for %s is %s°C.", 
              as.character(input$date), 
              round(runif(1, 15, 25), 1))  # Simulating a temperature prediction
    } else {
      initialText
    }
  })
  
  observeEvent(input$predict, {
    output$prediction <- renderText({
      sprintf("The predicted max temperature for %s is %s°C.", 
              as.character(input$date), 
              round(runif(1, 15, 25), 1))  # Simulating a temperature prediction
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

