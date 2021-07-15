# book-specific code to include on every page

library(shiny)
library(shinydashboard)

knitr::opts_chunk$set(
  warning = FALSE,
  message = FALSE
)

theme_set(theme_minimal())

is_pdf <- knitr::opts_knit$get("rmarkdown.pandoc.to") == "latex"
