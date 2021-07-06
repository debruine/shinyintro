# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinydashboard)
    library(ggplot2)
    library(DT)
})

# setup ----
theme_set(theme_minimal(base_size = 16)) # ggplot theme

# modules ----
tabPanelUI <- function(id, choices) {
    ns <- NS(id)
    
    tabPanel(
        id,
        selectInput(ns("dv"), "DV", choices = choices),
        plotOutput(ns("plot")),
        DT::dataTableOutput(ns("table"))
    )
}

tabPanelServer <- function(id, data, group_by) {
    moduleServer(id, function(input, output, session) {
        output$table <- DT::renderDataTable({
            data
        })
        
        output$plot <- renderPlot({
            # handle non-string groupings
            data[[group_by]] <- factor(data[[group_by]])
            ggplot(data, aes(x = .data[[group_by]], 
                             y = .data[[input$dv]],
                             fill = .data[[group_by]])) +
                geom_violin(alpha = 0.5, show.legend = FALSE) +
                scale_fill_viridis_d()
        })
    })
}

# UI ----
iris_tab <- tabPanelUI("iris", names(iris)[1:4])
mtcars_tab <- tabPanelUI("mtcars", c("mpg", "disp", "hp", "drat"))

ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "Modules Demo"),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        shinyjs::useShinyjs(),
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ), 
        tabsetPanel(
            iris_tab,
            mtcars_tab
        )
    )
)

# server ----
server <- function(input, output, session) {
    tabPanelServer("mtcars", data = mtcars, group_by = "vs")
    tabPanelServer("iris", data = iris, group_by = "Species")
} 

shinyApp(ui, server)