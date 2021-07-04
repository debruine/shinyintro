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