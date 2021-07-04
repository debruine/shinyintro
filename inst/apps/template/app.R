# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinyjs)
    library(shinydashboard)
    library(dplyr)
    library(tidyr)
    library(ggplot2)
    library(googlesheets4)
})

# setup ----
theme_set(theme_minimal(base_size = 16)) # ggplot theme

## authorise googlesheets
#options(gargle_oauth_cache = ".secrets")
gs4_auth(
    cache = ".secrets",
    email = "debruine@gmail.com"
)

# only create the questionnaire once and copy the ID directly below
# SHEET_ID <- gs4_create("questionnaire-demo", sheets = c("food")) 
SHEET_ID <- "1jAU_dRpBdmkf9gHC2oS2hUIE9tRKVlPITN91TmiD7Vk"

# functions ----

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
# define longer functions in external files
source("R/radio_table.R") # radio button tables that can toggle to drop-down menus
# source("R/sheet_append.R") # safer sheet_append function for development

# user interface ----

## tabs ----

# you can put complex tabs in separate files and source them
source("ui/pet_tab.R", local = TRUE)
#source("ui/food_tab.R", local = TRUE)

### food_tab ----

# set up tab in sheet if not there
if (gs4_has_token() &&
    !"food" %in% gs4_get(SHEET_ID)$sheets$name) {
    sheet_add(SHEET_ID, "food")
}

# radio_table setup
food_q <- list(
    apple = "Apples 🍎",
    banana = "Bananas 🍌",
    carrot = "Carrots 🥕",
    donut = "Donuts 🍩",
    eggplant = "Eggplants 🍆"
)

food_opts <- c(
    "Hate it",
    "Dislike it", 
    "Meh",
    "Like it",
    "Love it"
)

food_tab <- tabItem(
    tabName = "food_tab",
    box(id = "food_box", title = "Food Questionnaire", width = 12, collapsible = T,
        p("How much do you like each food?"),
        radioTableInput("food_table", food_q, food_opts, random = FALSE),
        actionButton("food_submit", "Submit")
    ),
    tabsetPanel(id = "food_plots",
        tabPanel("Individual Data", plotOutput("food_plot")),
        tabPanel("Summary Data", plotOutput("food_summary"))
    )
)


# if the header and/or sidebar get too complex, 
# put them in external files and uncomment below 
# source("ui/header.R", local = TRUE) # defines the `header`
# source("ui/sidebar.R", local = TRUE) # defines the `sidebar`

skin_color <- sample(c("red", "yellow", "green", "blue", "purple", "black"), 1)

## UI ----
ui <- dashboardPage(
    skin = skin_color,
    # header, # if sourced above
    dashboardHeader(title = "Template"),
    # sidebar, # if sourced above
    dashboardSidebar(
        # https://fontawesome.com/icons?d=gallery&m=free
        sidebarMenu(
            id = "tabs",
            menuItem("Pets", tabName = "pet_tab",
                     icon = icon("cat")),
            menuItem("Food", tabName = "food_tab",
                     icon = icon("apple"))
        )
    ),
    dashboardBody(
        shinyjs::useShinyjs(),
        tags$head(
            # links to files in www/
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"), 
            tags$link(rel = "stylesheet", type = "text/css", href = "radio-table.css"),
            tags$script(src = "custom.js"),
            tags$script(src = "radio-table.js")
        ),
        tabItems(
            food_tab, 
            pet_tab
        )
    )
)


# server ----
server <- function(input, output, session) {
    # get existing data
    v <- reactiveValues()
    v$food_summary_data <- read_sheet(SHEET_ID, "food")
    v$pet_summary_data <- read_sheet(SHEET_ID, "pet")
    
    iris <- readr::read_csv("iris.csv")
    message(iris)
    
    ## pet_submit ----
    observeEvent(input$pet_submit, { debug_msg("pet_submit")
        # save the data and update summary data
        data <- get_radio_table_inputs("pet_table", input, "wide")
        data$session_id <- session$token
        data$datetime <- Sys.time()
        sheet_append(SHEET_ID, data, "pet")
        v$pet_summary_data <- read_sheet(SHEET_ID, "pet")
        
        # show the summary plot and hide questionnaire
        updateTabsetPanel(session, "pet_plots", selected = "Summary Data")
        runjs("closeBox('pet_box');")
    })
    
    ## pet_plot ----
    output$pet_plot <- renderPlot({ debug_msg("pet_plot")
        data <- get_radio_table_inputs("pet_table", input, "long") %>%
            # to handle when all are NA
            mutate(answer = as.numeric(answer)) %>%
            # get in same order as table
            mutate(question = factor(question, names(pet_q)))
        
        ggplot(data, aes(x = question, y = answer, color = question)) +
            geom_point(size = 10, show.legend = FALSE) +
            scale_color_viridis_d() + 
            scale_x_discrete(name = "") +
            scale_y_continuous(name = "Pet Preference", breaks = 1:9, limits = c(1, 9))
    })
    
    ## pet_summary ----
    output$pet_summary <- renderPlot({ debug_msg("pet_summary")
        if (nrow(v$pet_summary_data) == 0) return()
        
        omit_vars <- c("session_id", "datetime")
        
        data <- v$pet_summary_data %>%
            pivot_longer(!any_of(omit_vars), 
                         names_to = "pet", 
                         values_to = "pref")  %>%
            # get in same order as table
            mutate(pet = factor(pet, names(pet_q)))
        
        # plot distribution of pet preference in each category
        g <- ggplot(data, aes(x = pet, y = pref, color = pet)) +
            scale_color_viridis_d() + 
            scale_x_discrete(name = "") +
            scale_y_continuous(name = "Pet Preference", breaks = 1:9, limits = c(1, 9))
        
        if (nrow(v$pet_summary_data) == 1) {
            # violins don't work with 1 row
            g + geom_point(size = 10, show.legend = FALSE)
        } else {
            g + geom_violin(aes(fill = pet), alpha = 0.5, show.legend = FALSE) +
                scale_fill_viridis_d()
        }
    })
    
    ## food_submit ----
    observeEvent(input$food_submit, { debug_msg("food_submit")
        # save the data and update summary data
        data <- get_radio_table_inputs("food_table", input, "wide")
        data$session_id <- session$token
        data$datetime <- Sys.time()
        sheet_append(SHEET_ID, data, "food")
        v$food_summary_data <- read_sheet(SHEET_ID, "food")
        
        # show the summary plot and hide questionnaire
        updateTabsetPanel(session, "food_plots", selected = "Summary Data")
        runjs("closeBox('food_box');")
    })
    
    ## food_plot ----
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
    
    ## food_summary ----
    output$food_summary <- renderPlot({ debug_msg("food_summary")
        if (nrow(v$food_summary_data) == 0) return()
        
        omit_vars <- c("session_id", "datetime")
        
        data <- v$food_summary_data %>%
            pivot_longer(!any_of(omit_vars), 
                         names_to = "food", 
                         values_to = "answer") %>%
            mutate(answer = factor(answer, food_opts))
        
        # plot number of foods in each category
        ggplot(data, aes(x = answer, fill = answer)) +
            geom_bar(show.legend = FALSE, na.rm = TRUE) +
            scale_fill_viridis_d() + 
            facet_wrap(~food) +
            scale_x_discrete(drop = FALSE, na.translate = FALSE)
    })
} 

shinyApp(ui, server)