# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinyjs)
    library(shinydashboard)
    library(ggplot2)
    library(dplyr)
})

# setup ----


# functions ----
source("scripts/func.R") # helper functions

# user interface ----


## UI ----
ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "Reactive Demo",
                    titleWidth = "100%"),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        shinyjs::useShinyjs(),
        tags$head(
            # links to files in www/
            tags$link(rel = "stylesheet", type = "text/css", href = "basic_template.css"),
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
            tags$script(src = "custom.js")
        ),
        box(width = 3,
            title = "Diamonds",
            solidHeader = TRUE,
            selectInput("cut", "Cut", levels(diamonds$cut)),
            selectInput("color", "Color", levels(diamonds$color)),
            selectInput("clarity", "Clarity", levels(diamonds$clarity)),
            actionButton("update", "Update Plot")
        ),
        box(width = 9,
            title = "Plot",
            solidHeader = TRUE,
            textOutput("title"),
            plotOutput("plot")
        )
    )
)


# server ----
server <- function(input, output, session) {
    output$plot <- renderPlot({
        data <- filter(diamonds,
                       cut == input$cut,
                       color == input$color,
                       clarity == input$clarity)
        
        ggplot(data, aes(carat, price)) +
            geom_point(color = "#605CA8", alpha = 0.5) +
            geom_smooth(method = lm, color = "#605CA8")
    })
    
    output$title <- renderText({
        input$update # just here to trigger the function
        
        sprintf("Cut: %s, Color: %s, Clarity: %s",
                input$cut,
                input$color,
                input$clarity)
    })
} 

shinyApp(ui, server)