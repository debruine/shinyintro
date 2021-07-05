# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinydashboard)
    library(ggplot2)
    library(dplyr)
    library(DT)
})

# display debugging messages in R if local, 
# or in the console log if remote
debug_msg <- function(...) {
    is_local <- Sys.getenv('SHINY_PORT') == ""
    txt <- toString(list(...))
    if (is_local) {
        message(txt)
    } else {
        shinyjs::logjs(txt)
    }
}

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
                 DT::dataTableOutput("demo_datatable"))
    )
)

## UI ----
ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "Output Demo"),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        shinyjs::useShinyjs(),
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
            stat_summary(fun.data = mean_cl_normal, show.legend = FALSE) +
            ylab(input$y)
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
        
        dpi <- 72
        w <- round(input$img_width / 72)
        h <- round(input$img_width / 1.62 / 72)

        ggsave(plot_file, demo_plot(), units = "in",
               dpi = dpi, width = w, height = h)
        
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
    output$demo_datatable <- DT::renderDataTable({
        iris
    }, options = list(pageLength = 10))
    
} 

shinyApp(ui, server)