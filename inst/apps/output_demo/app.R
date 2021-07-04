# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinydashboard)
    library(ggplot2)
    library(dplyr)
})

# user interface ----

main_tab <- tabItem(
    tabName = "main_tab",
    uiOutput("demo_ui"),
    tabsetPanel(
        tabPanel("plotOutput",
                 textOutput("demo_text", container = tags$h3),
                 plotOutput("demo_plot")),
        tabPanel("verbatimText",
                 p("Code for this plot"),
                 verbatimTextOutput("demo_verbatim")),
        tabPanel("imageOutput", 
                 sliderInput("img_width", "Saved image width in pixels", 500, 2500, 
                             value = 1500, step = 50),
                 p("The image is displayed at 100% screen width"),
                 imageOutput("demo_image")),
        tabPanel("tableOutput",
                 tableOutput("demo_table")),
        tabPanel("dataTableOutput",
                 dataTableOutput("demo_datatable"))
    )
)

## UI ----
ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "Output Demo"),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ), 
        main_tab
    )
)


# server ----
server <- function(input, output, session) {
    # make plot ----
    demo_plot <- reactive({
        if (is.null(input$y)) return(ggplot())
        
        ggplot(iris, aes(x = Species, y = .data[[input$y]], color = Species)) +
            geom_violin(show.legend = FALSE) +
            stat_summary(fun.data = mean_cl_normal, show.legend = FALSE)
    })

    # demo_ui ----
    output$demo_ui <- renderUI({
        cols <- names(iris)[1:4]
        selectInput("y", "Column to plot", cols, "Sepal.Length")
    })
    
    # demo_text ----
    output$demo_text <- renderText({
        sprintf("Plot of %s", input$y)
    })
    
    # demo_plot ----
    output$demo_plot <- renderPlot({
        demo_plot()
    })
    
    # demo_verbatim ----
    output$demo_verbatim <- renderText({
        code <- 
"ggplot(iris, aes(x = Species, y = %s, color = Species)) +
    geom_violin(show.legend = FALSE) +
    stat_summary(fun.data = mean_cl_normal, show.legend = FALSE)
                
ggsave('plot.png', units = \"px\", width = %d, height = %d)"
        
        sprintf(code, 
                input$y,
                input$img_width, 
                round(input$img_width/1.62))
    })
    
    # demo_image ----
    output$demo_image <- renderImage({
        plot_file <- tempfile(fileext = ".png")
        ggsave(plot_file, demo_plot(), units = "px",
               width = input$img_width, 
               height = round(input$img_width/1.62))
        
        # Return a list containing the filename
        list(src = plot_file,
             width = "100%",
             alt = "The plot")
    }, deleteFile = TRUE)
    
    # demo_table ----
    output$demo_table <- renderTable({
        iris %>%
            group_by(Species) %>%
            summarise(
                mean = mean(.data[[input$y]]),
                sd = sd(.data[[input$y]])
            )
    })
    
    # demo_datatable ----
    output$demo_datatable <- renderDataTable({
        iris
    }, options = list(pageLength = 10))
    
} 

shinyApp(ui, server)