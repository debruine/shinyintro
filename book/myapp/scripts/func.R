# display debugging messages in R if local, 
# or in the console log if remote
debug_msg <- function(...) {
  is_local <- Sys.getenv('SHINY_PORT') == ""
  txt <- toString(list(...))
  if (is_local) {
    message(txt)
  } else {
    shinyjs::runjs(sprintf("console.debug(\"%s\")", txt))
  }
}

debug_sprintf <- function(fmt, ...) {
  debug_msg(sprintf(fmt, ...))
}
