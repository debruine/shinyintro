# book-specific code to include on every page

library(shiny)
library(shinydashboard)

knitr::opts_chunk$set(
  warning = FALSE,
  message = FALSE
)

theme_set(theme_minimal())

is_pdf <- knitr::opts_knit$get("rmarkdown.pandoc.to") == "latex"

path <- function(txt) {
  sprintf("<code class='path'>%s</code>", txt)
}

pkg <- function(txt) {
  sprintf("<code class='package'>%s</code>", txt)
}

func <- function(txt) {
  sprintf("<code class='function'>%s()</code>", txt)
}

arg <- function(txt) {
  sprintf("<code class='argument'>%s</code>", txt)
}
