# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinyjs)
    library(shinydashboard)
})

# setup ----


# functions ----
source("scripts/func.R") # helper functions

# user interface ----

## tabs ----
x_tab <- tabItem(
    tabName = "x_tab",
    imageOutput("logo")
)

skin_color <- sample(c("red", "yellow", "green", "blue", "purple", "black"), 1)
random_icon <- sample(c("canadian-maple-leaf", "dragon", "user", "cog", 
                        "dice-d20", "dumpster-fire", "pastafarianism"), 1)

## UI ----
ui <- dashboardPage(
    skin = skin_color,
    dashboardHeader(title = "Basic Template"),
    dashboardSidebar(
        # https://fontawesome.com/icons?d=gallery&m=free
        sidebarMenu(
            id = "tabs",
            menuItem("Tab Title", tabName = "x_tab", icon = icon(random_icon))
        ),
        tags$a(href = "https://debruine.github.io/shinyintro/", 
               "ShinyIntro book", style="padding: 1em;")
    ),
    dashboardBody(
        shinyjs::useShinyjs(),
        tags$head(
            # links to files in www/
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"), 
            tags$script(src = "custom.js")
        ),
        tabItems(
            x_tab
        )
    )
)


# server ----
server <- function(input, output, session) {
    output$logo <- renderImage({
        list(src = "www/img/shinyintro.png",
             width = "300px",
             height = "300px",
             alt = "ShinyIntro hex logo")
    }, deleteFile = FALSE)
} 

shinyApp(ui, server)