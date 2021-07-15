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
demo_tab <- tabItem(
    tabName = "demo_tab",
    box(title = "Questions", id = "pet_box", solidHeader = TRUE,
        selectInput("had_pet", "Have you ever had a pet?", c("", "Yes", "No")),
        hidden(tags$div(id = "first_pet_grp",
                 selectInput("first_pet", "What was your first pet?", 
                             c("", "dog", "cat", "ferret", "other")),
                 textInput("first_pet_other", NULL, 
                           placeholder = "Specify the other pet")
        ))
    ),
    box(title = "Notice", solidHeader = TRUE,
        p(id = "notice_text", "Please pay attention to this text."),
        actionButton("add_notice", "Notice Me"),
        actionButton("remove_notice", "Ignore Me"),
        actionButton("toggle_notice", "Toggle Me")
    ),
    box(title = "Data", solidHeader = TRUE, width = 12,
        selectInput("dataset", "Choose a dataset", c("mtcars", "sleep")),
        checkboxGroupInput("columns", "Select the columns to show", inline = TRUE),
        tableOutput("data_table")
    )
)

## UI ----
ui <- dashboardPage(
    skin = "red",
    dashboardHeader(title = "Contingency Demo", 
        titleWidth = "calc(100% - 44px)" # puts sidebar toggle on right
    ),
    dashboardSidebar(
        # https://fontawesome.com/icons?d=gallery&m=free
        sidebarMenu(
            id = "tabs",
            menuItem("Pets", tabName = "demo_tab", icon = icon("dog"))
        ),
        tags$a(href = "https://debruine.github.io/shinyintro/", 
               "ShinyIntro book", style="padding: 1em;"),
        actionButton("toggle_pet_box", "Toggle Pet Questions"),
        actionButton("random_skin", "Random Skin")
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


# server ----
server <- function(input, output, session) {
    observeEvent(input$had_pet, {
        if (input$had_pet == "Yes") {
            show("first_pet_grp")
        } else {
            hide("first_pet_grp")
        }
    })
    
    observeEvent(input$first_pet, {
        if (input$first_pet == "other") {
            show("first_pet_other")
        } else {
            hide("first_pet_other")
        }
    })
    
    observeEvent(input$toggle_pet_box, {
        toggle("pet_box")
    })
    
    observeEvent(input$random_skin, {
        skins <- c("red", "yellow", "green", "blue", "purple", "black")
        skin_color <- sample(skins, 1)

        js <- sprintf("$('body').removeClass('%s').addClass('skin-%s');",
                      paste(paste0("skin-", skins), collapse = " "),
                      skin_color)

        shinyjs::runjs(js)
    })

    observeEvent(input$add_notice, {
        addClass("notice_text", "notice-me")
    })

    observeEvent(input$remove_notice, {
        removeClass("notice_text", "notice-me")
    })

    observeEvent(input$toggle_notice, {
        toggleClass("notice_text", "notice-me")
    })

    mydata <- reactive({
        d <- if (input$dataset == "mtcars") { mtcars } else { sleep }
        if (length(input$columns) == 0) {
            data.frame()
        } else {
            d[input$columns]
        }
    })

    output$data_table <- renderTable(mydata())

    observe({
        full_data <- if (input$dataset == "mtcars") { mtcars } else { sleep }
        col_names <- names(full_data)
        updateCheckboxGroupInput(
            session,
            inputId = "columns",
            choices = col_names,
            selected = col_names,
            inline = TRUE
        )
    })
} 

shinyApp(ui, server)