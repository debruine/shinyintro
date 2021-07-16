message("initialising googlesheets")

# set variables ----
email <- "debruine@gmail.com"
SHEET_ID <- "1jAU_dRpBdmkf9gHC2oS2hUIE9tRKVlPITN91TmiD7Vk"
sheet_name <- "questionnaire-demo3"
sheet_tabs <- c("food", "pet")

# load packages ----
suppressPackageStartupMessages({
  library(googlesheets4)
})

## authorise googlesheets ----
options(gargle_oauth_cache = ".secrets",
        gargle_oauth_email = email)
if (is.null(SHEET_ID)) googledrive::drive_auth()
gs4_auth()

# get sheet for this app ----
## this takes a long time, so it's better to set the SHEET_ID above
if (is.null(SHEET_ID)) {
  message(sprintf("finding %s", sheet_name))
  sheet <- gs4_find(sheet_name)
  if (length(sheet$id) == 0) {
    message(sprintf("creating %s", sheet_name))
    SHEET_ID <- gs4_create(sheet_name, sheets = sheet_tabs)
  } else {
    SHEET_ID <- sheet$id
  }
}

message(sprintf("SHEET_ID: %s", SHEET_ID))


# custom function for safer append ----

#' Append rows to a sheet safely
#'
#' Adds one or more new rows after the last row with data in a (work)sheet,
#' handling data with new columns, missing columns, columns in a different order,
#' or columns with a different data type.
#'
#' @param ss Google Sheet ID.
#' @param data A data frame.
#' @param sheet Sheet to append to.
#'
#' @return Google Sheet ID
sheet_append <- function(ss, data, sheet = 1) {
  # always use faster append on deployed apps
  is_local <- Sys.getenv('SHINY_PORT') == ""
  if (!is_local) {
    x <- googlesheets4::sheet_append(ss, data, sheet)
    return(x)
  }

  # safer append for a development environment
  data_sheet_orig <- read_sheet(ss, sheet)

  # convert data to characters to avoid bind problems
  data_sheet_char <- apply(data_sheet_orig, 2, as.character, simplify = FALSE)
  data_sheet <- as.data.frame(data_sheet_char)
  list_char <- apply(data, 2, as.character, simplify = FALSE)
  data_char <- as.data.frame(list_char)

  # bind and convert
  if (nrow(data_sheet) > 0) {
    data_bind <- dplyr::bind_rows(data_sheet, data_char)
  } else {
    data_bind <- data_char
  }
  data_conv <- type.convert(data_bind, as.is = TRUE)

  # get data types
  orig_types <- apply(data_sheet, 2, typeof)
  conv_types <- apply(data_conv, 2, typeof)

  if (identical(orig_types, conv_types)) {
    # append last row: fast and won't cause overwrite
    last_row <- data_conv[nrow(data_conv), ]
    googlesheets4::sheet_append(ss, last_row, sheet)
  } else {
    # the data has extra columns, or changes data types, so over-write
    # slower and might cause simultaneous access problems
    googlesheets4::write_sheet(data_conv, ss, sheet)
  }
}

#' Write googlesheet data to CSV
#' 
#' If you mix data types in a column, the data frame returned by `googlesheets4::read_sheet()` has list columns for any mixed columns. Dates can also get written in different ways that look the same when you print to the console, but are a mix of characters and doubles, so you have to convert them to strings like this before you can save as CSV.
#'
#' @param data The data frame to write
#' @param file File or connection to write to. 
#' @param ... Further arguments to pass to readr::write_csv
#'
gs4_write_csv <- function(data, file, ...) {
  string_data <- lapply(data, sapply, toString) %>% as.data.frame()
  readr::write_csv(string_data, file, ...)
}