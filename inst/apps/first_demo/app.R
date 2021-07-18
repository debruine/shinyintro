#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("My First App"),
  
  p("I am explaining this perfectly"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "display_var",
                   label = "Which variable to display",
                   choices = c("Waiting time to next eruption" = "waiting",
                               "Eruption time" = "eruptions"),
                   selected = "waiting"
      ),
      sliderInput("bins",
                  "Number of bins:",
                  min = 10,
                  max = 40,
                  value = 25)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # set x-axis label depending on the value of display_var
    if (input$display_var == "eruptions") {
      xlabel <- "Waiting Time to Next Eruption (in minutes)"
    } else if (input$display_var == "waiting") {
      xlabel <- "Waiting Time to Next Eruption (in minutes)"
    }
    
    # create plot
    ggplot(faithful, aes(.data[[input$display_var]])) +
      geom_histogram(bins = input$bins,
                     fill = "steelblue3",
                     colour = "grey30") +
      xlab(xlabel) +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)