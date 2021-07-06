# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinydashboard)
    library(ggplot2)
    library(DT)
})

# setup ----
theme_set(theme_minimal(base_size = 16)) # ggplot theme

# tabs ----
iris_tab <- tabPanel(
    "iris",
    selectInput("iris_dv", "DV", choices = names(iris)[1:4]),
    plotOutput("iris_plot"),
    DT::dataTableOutput("iris_table")
)

mtcars_tab <- tabPanel(
    "mtcars",
    selectInput("mtcars_dv", "DV", choices = c("mpg", "disp", "hp", "drat")),
    plotOutput("mtcars_plot"),
    DT::dataTableOutput("mtcars_table")
)

# UI ----
ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "No Modules Demo"),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        shinyjs::useShinyjs(),
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ), 
        fluidRow(
            infoBoxOutput("day_box", 4),
            infoBoxOutput("month_box", 4),
            infoBoxOutput("year_box", 4)
        ),
        tabsetPanel(
            iris_tab,
            mtcars_tab
        )
    )
)

# server ----
server <- function(input, output, session) {
    # iris_table ----
    output$iris_table <- DT::renderDataTable({
        iris
    })
    
    # iris_plot ----
    output$iris_plot <- renderPlot({
        ggplot(iris, aes(x = Species, 
                         y = .data[[input$iris_dv]],
                         fill = Species)) +
            geom_violin(alpha = 0.5, show.legend = FALSE) +
            scale_fill_viridis_d()
    })
    
    # mtcars_table ----
    output$mtcars_table <- DT::renderDataTable({
        mtcars
    })
    
    # mtcars_plot ----
    output$mtcars_plot <- renderPlot({
        # handle non-string grouping
        mtcars$vs <- factor(mtcars$vs)
        ggplot(mtcars, aes(x = vs, 
                           y = .data[[input$mtcars_dv]],
                           fill = vs)) +
            geom_violin(alpha = 0.5, show.legend = FALSE) +
            scale_fill_viridis_d()
    })
    
    # info boxes ----
    output$year_box <- renderInfoBox({
        infoBox(title = "Year",
                value = format(Sys.Date(), "%Y"),
                icon = icon("calendar"),
                color = "purple"
        )
    })
    
    output$month_box <- renderInfoBox({
        infoBox(title = "Month",
                value = format(Sys.Date(), "%m"),
                icon = icon("calendar-alt"),
                color = "purple"
        )
    })
    
    output$day_box <- renderInfoBox({
        infoBox(title = "Day",
                value = format(Sys.Date(), "%d"),
                icon = icon("calendar-day"),
                color = "purple"
        )
    })
} 

shinyApp(ui, server)