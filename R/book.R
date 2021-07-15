#' Open the shinyintro book
#'
#' @return NULL
#' @export
#'
book <- function() {
  file <- system.file("book", "index.html", package = "shinyintro")
  utils::browseURL(file)
}
