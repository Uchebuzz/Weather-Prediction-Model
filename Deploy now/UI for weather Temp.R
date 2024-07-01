
library(shiny)
library(shinythemes)

# Define UI
ui <- fluidPage(
  theme = shinytheme("united"),  
  
  titlePanel(h1("Wolverhampton Weather Prediction", icon("sun")),
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
                  choices = c("Linear Regression", "Decision Tree", "Random Forest",
                              "ARIMA", "Ridge Regression")),
      
      br(),
      actionButton("predict",
                   "Predict Temperature",
                   icon = icon("thermometer-half"),
                   class = "btn-success"),
      tags$hr(),
      tags$p("Developed by Uche."),
      # Cloud Animation
      tags$div(class = "cloud-container",
               tags$div(class = "cloud"))
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
      sprintf("The predicted temperature for %s using %s model is %s°C.", 
              as.character(input$date), 
              input$model,
              round(runif(1, 15, 25), 1))  
    } else {
      initialText
    }
  })
  
  observeEvent(input$predict, {
    output$prediction <- renderText({
      sprintf("The predicted temperature for %s using %s model is %s°C.", 
              as.character(input$date), 
              input$model,
              round(runif(1, 15, 25), 1)) 
    })
  })
}


css <- "
.cloud-container {
  position: relative;
  width: 100%;
  height: 100px;
  overflow: hidden;
  margin-top: 20px;
}

.cloud {
  position: absolute;
  width: 200px;
  height: 60px;
  background: #f2f2f2;
  border-radius: 200px;
  box-shadow: 10px 10px 10px rgba(0, 0, 0, 0.1);
  animation: moveClouds 15s linear infinite;
}

@keyframes moveClouds {
  0% {
    left: -200px;
  }
  100% {
    left: 100%;
  }
}
"

# Add the CSS to the UI
ui <- tagList(
  tags$head(
    tags$style(HTML(css))
  ),
  ui
)

# Run the application 
shinyApp(ui = ui, server = server)
