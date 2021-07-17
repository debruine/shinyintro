#' Questionnaire UI
#'
#' @param id Unique ID for the questionnaire
#' @param title Box title
#' @param instructions Instructions to display at the top of the questionnaire
#' @param questions A named list of questions (names are ID values for each question)
#' @param opts A list of options (formatted like \code{selectInput} choices argument)
#' @param ... Options to pass to radioTableInput, defaults: reversed = c(), q_width = "25%", random = TRUE
#'
#' @return tabItem HTML
questUI <- function(id, title = "Questionnaire", instructions = "", 
                    questions = c(Q1 = "?"), 
                    opts = c(yuck = 1, meh = 2, yum = 3),
                    ...) {
  ns <- NS(id)
  
  tabItem(
    tabName = ns("tab"),
    box(id = ns("box"), 
        title = title, 
        width = 12, 
        collapsible = TRUE,
        collapsed = FALSE,
        solidHeader = TRUE,
        p(instructions),
        radioTableInput(ns("table"), questions, opts, NS_id = id, ...),
        actionButton(ns("submit"), "Submit")
    ),
    tabsetPanel(id = ns("plots"),
                tabPanel("Individual Data", withSpinner(plotOutput(ns("plot")))),
                tabPanel("Summary Data", withSpinner(plotOutput(ns("summary"))))
    )
  )
}


questServer <- function(id, USING_GS4 = FALSE, 
                        plot_func = function(data) { ggplot(data) }, 
                        summary_func = function(data) { ggplot(data) }) {
  moduleServer(id, function(input, output, session) {
    debug_sprintf("== Setting up %s Questionnaire ==", id)
    
    v <- reactiveValues()
    table_id <- sprintf("%s-table", id)
    sheet_name <- id
    csv_file <- sprintf("data/%s.csv", id)
    
    # set up tab in sheet if not there ----
    if (USING_GS4 &&
        !sheet_name %in% gs4_get(SHEET_ID)$sheets$name) {
      sheet_add(SHEET_ID, sheet_name)
    } else if (!file.exists(csv_file)) {
      write_csv(data.frame(), csv_file)
    }
    
    ## get summary data ----
    if (USING_GS4) {
      debug_msg("getting remote data")
      v$summary_data <- read_sheet(SHEET_ID, sheet_name)
    } else {
      debug_msg("getting local data")
      v$summary_data <- read_csv(csv_file, col_types = cols())
    }
    
    ## submit ----
    observeEvent(input$submit, { debug_sprintf("%s-submit", id)
      debug_msg(input)
      # save the data and update summary data
      new_data <- get_radio_table_inputs(table_id, input, "wide")
      new_data$session_id <- session$token
      new_data$datetime <- Sys.time()
      if (USING_GS4) {
        sheet_append(SHEET_ID, new_data, sheet_name)
        v$summary_data <- read_sheet(SHEET_ID, sheet_name)
      } else {
        old_data <- read_csv(csv_file)
        v$summary_data <- bind_rows(old_data, new_data)
        write_csv(v$summary_data, csv_file)
      }
      
      # show the summary plot and hide questionnaire
      updateTabsetPanel(session, "plots", selected = "Summary Data")
      runjs(sprintf("closeBox('%s_box');", id))
    })
    
    ## plot ----
    output$plot <- renderPlot({ debug_sprintf("%s-plot", id)
      data <- get_radio_table_inputs(table_id, input, "long")
      plot_func(data)
    })
    
    ## summary ----
    output$summary <- renderPlot({ debug_sprintf("%s-summary", id)
      summary_func(v$summary_data)
    })
  })
}
