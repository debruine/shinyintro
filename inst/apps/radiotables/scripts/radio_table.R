#' Get Radio Table Inputs
#'
#' Get input values by table ID as a named list, a wide data table (1 row), or a long data table (1 row per question).
#' 
#' @param id table ID
#' @param input the input list
#' @param output output format
#'
#' @return named list of input values
get_radio_table_inputs <- function(id, input, 
                                   output = c("list", "wide", "long")) {
  debug_sprintf("get_radio_table_inputs(%s)", id)
  varnames <- radio_table_vars[[id]]
  vars <- lapply(varnames, function(x) input[[x]])
  vars <- type.convert(vars, as.is = TRUE)
  names(vars) <- varnames
  
  
  switch(output,
    list = vars,
    wide = as.data.frame(vars),
    long = data.frame(question = names(vars), answer = unlist(vars))
  )
}


#' Radio Table Input
#' 
#' Group questions with the same options in a table that can toggle to a list of drop-down menus
#'
#' @param id The ID value for the table
#' @param q A named list of questions (names are ID values for each question)
#' @param opts A list of options (formatted like \code{selectInput} choices argument)
#' @param reversed A list of question IDs (or their numeric indices) for reverse-coded questions
#' @param q_width The width of the first question column (defaults to 25%); all other columns are equally sized
#' @param random Whether to randomise the order of the questions
#' @param NS_id Set to the namespace the function is being used inside a module
#'
#' @return The HTML for the tabular input interface
radioTableInput <- function(id, q, opts, reversed = c(), q_width = "25%", random = TRUE, NS_id = NULL) {
  opts <- opts[opts != ""] # remove blanks (re-add later)
  if (is.null(names(opts))) names(opts) <- opts
  
  # record question names to a global variable 
  # TODO: better version of this!
  if (is.null(names(q))) names(q) <- paste0(id, "_", seq_along(q))
  if (!exists("radio_table_vars", envir = .GlobalEnv)) {
    assign("radio_table_vars", list(), .GlobalEnv)
  }
  radio_table_vars[[id]] <<- names(q)
  names(q) <- NS(NS_id, names(q)) # handle modules

  
  # get reversed by name or index
  if (is.numeric(reversed)) {
    reversed <- names(q)[reversed]
  } else {
    reversed <- NS(NS_id, reversed) # handle modules
  }
  
  if (isTRUE(random)) q <- sample(q)
  
  # make table thead
  w <- sprintf("width: %s;", q_width)
  question_cell <- tags$th(style=w, "")
  option_cells <- lapply(names(opts), tags$th)
  label_list <- c(list(question_cell), option_cells)
  thead <- tags$thead(do.call(tags$tr, label_list))
  
  # make table tbody
  table_rows <- mapply(function(quest, qid) {
    vals <- unname(opts)
    choices <- c("", opts)
    if (qid %in% reversed) {
      vals <- rev(vals)
      choices[names(opts)] <- vals
    }
    
    question <- tags$td(class = "radio-question", name = qid,
                        tags$label(quest, class="radio-label"), # question to display
                        selectInput(qid, quest, choices = choices) # hidden select
    )
    
    radio_buttons <- lapply(vals, function(v) {
      tags$td(class = "radio-button",
              tags$input(type = "radio", name = qid, value = v)
      )
    })
    
    table_cells <- c(list(question), radio_buttons)
    
    # return table row
    do.call(tags$tr, table_cells)
  }, q, names(q), SIMPLIFY = FALSE)
  
  tbody <- do.call(tags$tbody, unname(table_rows))
  
  # return table
  tags$table(id = id, class = "radio-table", 
             tags$input(type="button", class="radio-toggle", value = "Toggle View"),
             thead, tbody)
}
