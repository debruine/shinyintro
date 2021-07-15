#' Clone a new shiny app from a template
#'
#' @param app the template app to copy
#' @param dir the app directory to create
#'
#' @return boolean (if the directory was copied)
#' @export
#'
clone <- function(app = "basic_template", dir = app) {
  if (dir.exists(dir)) {
    stop("The directory ", dir, " already exists.")
  }
  
  tmpDir <- system.file("apps", app, package = "shinyintro")
  
  R.utils::copyDirectory(
    from = tmpDir,
    to = dir, 
    private = FALSE,
    overwrite = FALSE, 
    recursive = TRUE)
  
  utils::browseURL(paste0(dir, "/app.R"))
}