# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinyjs)
    library(shinydashboard)
    library(readr)
    library(dplyr)
    library(tidyr)
    library(ggplot2)
    library(shinycssloaders)
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
source("ui/q_module.R")
source("ui/pet_tab.R", local = TRUE)
source("ui/food_tab.R", local = TRUE)
source("ui/hand_tab.R", local = TRUE)
source("ui/bpaq_tab.R", local = TRUE)

skin_color <- sample(c("red", "yellow", "green", "blue", "purple", "black"), 1)

## UI ----
ui <- dashboardPage(
    skin = skin_color,
    dashboardHeader(title = "ShinyIntro"),
    dashboardSidebar(
        # https://fontawesome.com/icons?d=gallery&m=free
        sidebarMenu(
            id = "tabs",
            menuItem("Pets", tabName = "pet-tab",
                     icon = icon("paw")),
            menuItem("Food", tabName = "food-tab",
                     icon = icon("apple-alt")),
            menuItem("Hand", tabName = "hand-tab",
                     icon = icon("hand-paper")),
            menuItem("BPAQ", tabName = "bpaq-tab",
                     icon = icon("hand-rock"))
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
            food_tab,
            hand_tab,
            bpaq_tab
        )
    )
)


# server ----
server <- function(input, output, session) {
    ## questionnaires from modules ----
    questServer("pet", USING_GS4, pet_plot, pet_summary)
    questServer("food", USING_GS4, food_plot, food_summary)
    questServer("hand", USING_GS4, hand_plot, hand_summary)
    questServer("bpaq", USING_GS4, bpaq_plot, bpaq_summary)
} 

shinyApp(ui, server)