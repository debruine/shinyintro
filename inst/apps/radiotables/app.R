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
source("scripts/func.R") # helper functions
source("scripts/radio_table.R") # radio button tables
source("scripts/gs4.R") # save data using googlesheets

# checks if you're using googlesheets
USING_GS4 <- "googlesheets4" %in% (.packages()) && gs4_has_token()

# user interface ----

## tabs ----
source("ui/pet_tab.R", local = TRUE)
source("ui/food_tab.R", local = TRUE)

skin_color <- sample(c("red", "yellow", "green", "blue", "purple", "black"), 1)

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
        tabItems(
            pet_tab,
            food_tab
        )
    )
)


# server ----
server <- function(input, output, session) {
    ## get existing data ----
    v <- reactiveValues()
    v$small_screen <- FALSE
    
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
    
    ## widow resize functions ----
    observeEvent(c(input$window_width, input$window_height), { 
        # debug_sprintf("window_width = %d", input$window_width)
        # debug_sprintf("window_height = %d", input$window_height)
        
        # only change reactive value on threshold change 
        # to avoid constant triggers
        if (input$window_width < 600 && !v$small_screen) {
            v$small_screen <- TRUE
        }
        if (input$window_width >= 600 && v$small_screen) {
            v$small_screen <- FALSE
        }
    })
    
    ## pets ----
    ### pet_submit ----
    observeEvent(input$pet_submit, { debug_msg("pet_submit")
        # save the data and update summary data
        data <- get_radio_table_inputs("pet_table", input, "wide")
        data$session_id <- session$token
        data$datetime <- Sys.time()
        if (USING_GS4) {
            sheet_append(SHEET_ID, data, "pet")
            v$pet_summary_data <- read_sheet(SHEET_ID, "pet")
        } else {
            old_data <- read_csv("data/pet.csv")
            v$pet_summary_data <- bind_rows(old_data, data)
            write_csv(v$pet_summary_data, "data/pet.csv")
        }
        
        # show the summary plot and hide questionnaire
        updateTabsetPanel(session, "pet_plots", selected = "Summary Data")
        runjs("closeBox('pet_box');")
    })
    
    ### pet_plot ----
    output$pet_plot <- renderPlot({ debug_msg("pet_plot")
        data <- get_radio_table_inputs("pet_table", input, "long") %>%
            # to handle when all are NA
            mutate(answer = as.numeric(answer)) %>%
            # get in same order as table
            mutate(question = factor(question, names(pet_q)))
        
        ggplot(data, aes(x = question, y = answer, color = question)) +
            geom_point(size = 10, show.legend = FALSE, na.rm = TRUE) +
            scale_color_viridis_d() + 
            scale_x_discrete(name = "") +
            scale_y_continuous(name = "Pet Preference", breaks = 1:9, limits = c(1, 9))
    })
    
    ### pet_summary ----
    output$pet_summary <- renderPlot({ debug_msg("pet_summary")
        if (nrow(v$pet_summary_data) == 0) return()
        
        omit_vars <- c("session_id", "datetime")
        
        data <- v$pet_summary_data %>%
            pivot_longer(-(omit_vars), 
                         names_to = "pet", 
                         values_to = "pref")  %>%
            # get in same order as table
            mutate(pet = factor(pet, names(pet_q)))
        
        # plot distribution of pet preference in each category
        g <- ggplot(data, aes(x = pet, y = pref, color = pet)) +
            scale_color_viridis_d() + 
            scale_x_discrete(name = "") +
            scale_y_continuous(name = "Pet Preference", breaks = 1:9, limits = c(1, 9))
        
        # rotate x-axis text on small screens
        if (v$small_screen) {
            g <- g + theme(axis.text.x=element_text(angle=90,hjust=1))
        }
        
        if (nrow(v$pet_summary_data) == 1) {
            # violins don't work with 1 row
            g + geom_point(size = 10, show.legend = FALSE)
        } else {
            g + geom_violin(aes(fill = pet), alpha = 0.5, show.legend = FALSE) +
                scale_fill_viridis_d()
        }
    })
    
    ## food ----
    ### food_submit ----
    observeEvent(input$food_submit, { debug_msg("food_submit")
        # save the data and update summary data
        data <- get_radio_table_inputs("food_table", input, "wide")
        data$session_id <- session$token
        data$datetime <- Sys.time()
        if (USING_GS4) {
            sheet_append(SHEET_ID, data, "food")
            v$food_summary_data <- read_sheet(SHEET_ID, "food")
        } else {
            old_data <- read_csv("data/food.csv")
            v$food_summary_data <- bind_rows(old_data, data)
            write_csv(v$food_summary_data, "data/food.csv")
        }

        # show the summary plot and hide questionnaire
        updateTabsetPanel(session, "food_plots", selected = "Summary Data")
        runjs("closeBox('food_box');")
    })

    ### food_plot ----
    output$food_plot <- renderPlot({ debug_msg("food_plot")
        get_radio_table_inputs("food_table", input, "long") %>%
            # make answer a factor for empty categories
            mutate(answer = factor(answer, food_opts)) %>%
            # plot number of foods in each category
            ggplot(aes(x = answer, fill = answer)) +
            geom_bar(show.legend = FALSE, na.rm = TRUE) +
            scale_fill_viridis_d() +
            # keep empty categories, not NAs
            scale_x_discrete(drop = FALSE, na.translate = FALSE)
    })

    ### food_summary ----
    output$food_summary <- renderPlot({ debug_msg("food_summary")
        if (nrow(v$food_summary_data) == 0) return()

        omit_vars <- c("session_id", "datetime")

        data <- v$food_summary_data %>%
            pivot_longer(-(omit_vars),
                         names_to = "food",
                         values_to = "answer") %>%
            mutate(answer = factor(answer, food_opts))

        plot_cols <- ifelse(v$small_screen, 1, 2)

        # plot number of foods in each category
        ggplot(data, aes(x = answer, fill = answer)) +
            geom_bar(show.legend = FALSE, na.rm = TRUE) +
            scale_fill_viridis_d() +
            facet_wrap(~food, ncol = plot_cols) +
            scale_x_discrete(drop = FALSE, na.translate = FALSE)
    })
} 

shinyApp(ui, server)