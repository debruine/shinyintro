#' Open the shinyintro book
#'
#' @return NULL
#' @export
#'
book <- function() {
  file <- system.file("book", "index.html", package = "shinyintro")
  utils::browseURL(file)
}

#' Launch Shiny App
#'
#' @param name The name of the app to run
#' @param ... arguments to pass to shiny::runApp
#'
#' @export
#'
app <- function(name = "template", ...) {
  appDir <- system.file(paste0("apps/", name), package = "shinyintro")
  if (appDir == "") stop("The shiny app ", name, " does not exist")
  shiny::runApp(appDir, ...)
}

#' Set up a new shiny app from a template
#'
#' @param dir the app directory to create
#' @param app the template app to copy
#'
#' @return boolean (if the directory was copied)
#' @export
#'
newapp <- function(dir = "myapp", app = "input_demo") {
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