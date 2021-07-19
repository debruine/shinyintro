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
  sprintf("<code><span class='fu'>%s</span>()</code>", txt)
}

arg <- function(txt) {
  sprintf("<code><span class='at'>%s</span></code>", txt)
}

dt <- function(val) {
  class <- switch(typeof(val), 
                  character = "st", 
                  integer = "fl", 
                  double = "fl", 
                  logical = "cn",
                  closure = "fu",
                  "")
  txt <- toString(val)
  if (class == "st") txt <- sprintf("&quot;%s&quot;", txt)
  
  sprintf("<code><span class='%s'>%s</span></code>", class, txt)
}
