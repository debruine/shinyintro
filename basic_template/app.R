# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinyjs)
    library(shinydashboard)
})

# setup ----


# functions ----
source("scripts/func.R") # helper functions

col_is_char <- sapply(starwars, is.character)
categorical_cols <- names(starwars)[col_is_char]

# set up the selectInputs
select_inputs <- lapply(categorical_cols, function(col) {
    unique_vals <- unique(starwars[[col]])
    
    selectInput(inputId = col, label = col, choices = unique_vals)
})

# add container arguments to select_inputs 
select_inputs$title = "Select the Categories"
select_inputs$solidHeader = TRUE
select_inputs$width = 4

# add to container
select_box <- do.call(box, select_inputs)

# user interface ----

## tabs ----
demo_tab <- tabItem(
    tabName = "demo_tab",
    select_box
)

skin_color <- sample(c("red", "yellow", "green", "blue", "purple", "black"), 1)
random_icon <- sample(c("canadian-maple-leaf", "dragon", "user", "cog", 
                        "dice-d20", "dumpster-fire", "pastafarianism"), 1)
## UI ----
ui <- dashboardPage(
    skin = skin_color,
    dashboardHeader(title = "Basic Template", 
        titleWidth = "calc(100% - 44px)" # puts sidebar toggle on right
    ),
    dashboardSidebar(
        # https://fontawesome.com/icons?d=gallery&m=free
        sidebarMenu(
            id = "tabs",
            menuItem("Tab Title", tabName = "demo_tab", icon = icon(random_icon))
        ),
        tags$a(href = "https://debruine.github.io/shinyintro/", 
               "ShinyIntro book", style="padding: 1em;")
    ),
    dashboardBody(
        shinyjs::useShinyjs(),
        tags$head(
            # links to files in www/
            tags$link(rel = "stylesheet", type = "text/css", href = "basic_template.css"), 
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"), 
            tags$script(src = "custom.js")
        ),
        tabItems(
            demo_tab
        )
    )
)

source("scripts/logo.R")

# server ----
server <- function(input, output, session) {
    output$logo <- renderImage({
        logo_image(input$change)
    }, deleteFile = FALSE)
} 

shinyApp(ui, server)