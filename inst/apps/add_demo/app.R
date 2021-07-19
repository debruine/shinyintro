# Load libraries ----
library(shiny)

# Define UI ----
ui <- fluidPage(
  titlePanel("Addition Demo"),
  sidebarLayout(
    sidebarPanel(
      numericInput("n1", "First number", 0),
      numericInput("n2", "Second number", 0),
      actionButton("add", "Add Numbers")
    ),
    mainPanel(
      textOutput(outputId = "n1_plus_n2")
    )
  )
)

# Define server logic ----

## observeEvent pattern ----
server <- function(input, output) {
  # add numbers
  observeEvent(input$add, {
    input_error <- dplyr::case_when(
      !is.numeric(input$n1) ~ "N1 needs to be a number",
      !is.numeric(input$n2) ~ "N2 needs to be a number",
      TRUE ~ ""
    )
    if (input_error != "") {
      showModal(modalDialog(
        title = "Error",
        input_error,
        easyClose = TRUE
      ))
      return() # exit the function here
    }
    
    # no input errors
    sum <- input$n1 + input$n2
    add_text <- sprintf("%d + %d = %d", input$n1, input$n2, sum)
    output$n1_plus_n2 <- renderText(add_text)
  })
}

## reactive pattern
# server <- function(input, output) {
#   add_text <- reactive({
#     input$add # triggers reactive
#     n1 <- isolate(input$n1)
#     n2 <- isolate(input$n2)
#     validate(
#       need(!is.na(n1), "The first value must a number"),
#       need(!is.na(n2), "The second value must a number")
#     )
#     
#     sprintf("%d + %d = %d", n1, n2, n1 + n2)
#   })
# 
#   output$n1_plus_n2 <- renderText(add_text())
# }

# Run the application ----
shinyApp(ui = ui, server = server)