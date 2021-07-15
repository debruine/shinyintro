# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinydashboard)
})

# user interface ----

demo_text <- 
    textInput("demo_text", 
              label = "Name", 
              value = "", 
              width = "100%",
              placeholder = "Your Name")

demo_textarea <- 
    textAreaInput("demo_textarea", 
                  label = "Biography", 
                  value = "", 
                  width = "100%",
                  rows = 5, 
                  placeholder = "Tell us something interesting about you.")

demo_select <- 
    selectInput("demo_select", 
                label = "Do you like Shiny?", 
                choices = list("", 
                               "Yes, I do" = "y", 
                               "No, I don't" = "n"),
                selected = NULL,
                width = "100%")

genders <- list( # no blank needed
    "Non-binary" = "nb",
    "Male" = "m",
    "Female" = "f",
    "Agender" = "a",
    "Gender Fluid" = "gf"
)

demo_cbgi <-
    checkboxGroupInput("demo_cbgi",
                       label = "Gender (select all that apply)",
                       choices = genders)

demo_cb <- checkboxInput("demo_cb",
                         label = "I love R",
                         value = TRUE)

demo_slider <- sliderInput("demo_slider",
                           label = "Age",
                           min = 0,
                           max = 100,
                           value = 0,
                           step = 1,
                           width = "100%")
                           
demo_radio <- radioButtons("demo_radio",
                           label = "Choose one",
                           choices = c("Cats", "Dogs"))

main_tab <- tabItem(
    tabName = "main_tab",
    p("We're not recording anything here."),
    fluidRow(
        column(width = 6, 
                demo_text,
                demo_textarea,
                demo_select),
        column(width = 6,
                demo_cbgi,
                demo_slider,
                demo_cb,
                demo_radio)
    ),
    actionButton("reset", "Reset")
)

## UI ----
ui <- dashboardPage(
    skin = "purple",
    dashboardHeader(title = "Input Demo"),
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
    # reset values
    observeEvent(input$reset, {
        updateTextInput(session, "demo_text", value = "")
        updateTextAreaInput(session, "demo_textarea", value = "")
        updateSelectInput(session, "demo_select", selected = "")
        updateCheckboxGroupInput(session, "demo_cbgi", selected = character(0))
        updateCheckboxInput(session, "demo_cb", value = TRUE)
        updateSliderInput(session, "demo_slider", value = 0)
    })
} 

shinyApp(ui, server)