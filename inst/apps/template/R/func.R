# display debugging messages in R if local, 
# or in the console log if remote
debug_msg <- function(...) {
  is_local <- Sys.getenv('SHINY_PORT') == ""
  txt <- paste(...)
  if (is_local) {
    message(txt)
  } else {
    shinyjs::logjs(txt)
  }
}