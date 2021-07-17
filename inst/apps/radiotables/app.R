# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinyjs)
    library(shinydashboard)
    library(readr)
    library(dplyr)
    library(tidyr)
    library(ggplot2)
})

# setup ----
theme_set(theme_minimal(base_size = 16)) # ggplot theme

# functions ----
source("scripts/quest_vars.R") # questionnaire Q&A lists
source("scripts/func.R") # helper functions
source("scripts/radio_table.R") # radio button tables
source("scripts/gs4.R") # save data using googlesheets

# checks if you're using googlesheets
USING_GS4 <- "googlesheets4" %in% (.packages()) && gs4_has_token()

# user interface ----

## tabs ----
source("ui/pet_tab.R", local = TRUE)
source("ui/food_tab.R", local = TRUE)

skin_color <-
    sample(c("red", "yellow", "green", "blue", "purple", "black"), 1)

## UI ----
ui <- dashboardPage(
    skin = skin_color,
    dashboardHeader(title = "ShinyIntro"),
    dashboardSidebar(
        # https://fontawesome.com/icons?d=gallery&m=free
        sidebarMenu(
            id = "tabs",
            menuItem("Pets", tabName = "pet_tab",
                     icon = icon("paw")),
            menuItem("Food", tabName = "food_tab",
                     icon = icon("apple-alt"))
        ),
        tags$img(src = "img/shinyintro.png",
                 width = "100%")
    ),
    dashboardBody(
        shinyjs::useShinyjs(),
        tags$head(
            # links to files in www/
            tags$link(rel = "stylesheet", type = "text/css", href = "radio-table.css"),
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
            tags$script(src = "radio-table.js"),
            tags$script(src = "custom.js")
        ),
        tabItems(pet_tab,
                 food_tab)
    )
)


# server ----
server <- function(input, output, session) {
    ## set up reactives ----
    v <- reactiveValues()
    v$small_screen <- FALSE
    
    ## window resize function ----
    observeEvent(input$window_width, {
        # only change on threshold to avoid constant triggers
        if (input$window_width < 600 && !v$small_screen) {
            v$small_screen <- TRUE
        } else if (v$small_screen) {
            v$small_screen <- FALSE
        }
    })
    
    ## get existing data ----
    if (USING_GS4) {
        debug_msg("getting remote data")
        v$food_summary_data <- read_sheet(SHEET_ID, "food")
        v$pet_summary_data <- read_sheet(SHEET_ID, "pet")
    } else {
        debug_msg("getting local data")
        v$food_summary_data <- read_csv("data/food.csv",
                                        col_types = cols())
        v$pet_summary_data <- read_csv("data/pet.csv",
                                       col_types = cols())
    }
    
    ## pets ----
    ### pet_submit ----
    observeEvent(input$pet_submit, {
        debug_msg("pet_submit")
        # save the data and update summary data
        data <- get_radio_table_inputs("pet_table", input, "wide")
        data$session_id <- session$token
        v$pet_summary_data <- append_pet_data(data, USING_GS4)
        
        # show the summary plot and hide questionnaire
        updateTabsetPanel(session, "pet_plots", selected = "Summary Data")
        runjs("closeBox('pet_box');")
    })
    
    ### pet_plot ----
    output$pet_plot <- renderPlot({ debug_msg("pet_plot")
        pet_data <- get_radio_table_inputs("pet_table", input, "long") 
        make_pet_plot(pet_data)
    })
    
    ### pet_summary ----
    output$pet_summary <- renderPlot({ debug_msg("pet_summary")
        make_pet_summary_plot(v$pet_summary_data, v$small_screen)
    })
    
    
    ## food ----
    ### food_submit ----
    observeEvent(input$food_submit, { debug_msg("food_submit")
        # save the data and update summary data
        data <- get_radio_table_inputs("food_table", input, "wide")
        data$session_id <- session$token
        v$food_summary_data <- append_food_data(data, USING_GS4)
        
        # show the summary plot and hide questionnaire
        updateTabsetPanel(session, "food_plots", selected = "Summary Data")
        runjs("closeBox('food_box');")
    })
    
    ### food_plot ----
    output$food_plot <- renderPlot({ debug_msg("food_plot")
        data <- get_radio_table_inputs("food_table", input, "long") 
        make_food_plot(data)
    })
    
    ### food_summary ----
    output$food_summary <- renderPlot({ debug_msg("food_summary")
        make_food_summary_plot(v$food_summary_data, v$small_screen)
    })
}

shinyApp(ui, server)