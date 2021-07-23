# book-specific code to include on every page
suppressPackageStartupMessages({
  library(shiny)
  library(shinydashboard)
})

knitr::opts_chunk$set(
  warning = FALSE,
  message = FALSE
)

theme_set(theme_minimal())

is_html <- knitr::opts_knit$get("rmarkdown.pandoc.to") == "html"

tex_replace <- function(txt) {
  for (char in c("#", "_", " ", "$", "{", "}")) {
    txt <- gsub(char, paste0("\\", char), txt, fixed = TRUE)
  }
  txt
}

path <- function(txt) {
  if (is_html) {
    sprintf("<code class='path'>%s</code>", txt)
  } else {
    sprintf("\\textit{\\texttt{%s}}", tex_replace(txt))
  }
}

pkg <- function(txt) {
  if (is_html) {
    sprintf("<code class='package'>%s</code>", txt)
  } else {
    sprintf("\\textbf{\\texttt{%s}}", tex_replace(txt))
  }
}


func <- function(txt, args = "") {
  if (is_html) {
    sprintf("<code><span class='fu'>%s</span>(%s)</code>", txt, args)
  } else {
    sprintf("\\texttt{%s}\\texttt{(%s)}", tex_replace(txt), tex_replace(args))
  }
}

arg <- function(txt) {
  dt(txt, "at")
}

dt <- function(val, class = NULL) {
  if (is.null(class)) {
    class <- switch(typeof(val), 
                    character = "st", 
                    integer = "fl", 
                    double = "fl", 
                    logical = "cn",
                    closure = "fu",
                    "")
  }
  txt <- toString(val)
  
  if (is_html) {
    if (class == "st") txt <- sprintf("&quot;%s&quot;", txt)
    txt <- gsub("<", "&lt;", txt, fixed = TRUE)
    sprintf("<code><span class='%s'>%s</span></code>", class, txt)
  } else {
    if (class == "st") txt <- sprintf("\"%s\"", txt)
    textok <- switch(
      class,
      st = "String",
      fu = "Function",
      at = "Attribute",
      fl = "DecVal",
      cn = "Constant",
      "Normal"
    )
    
    sprintf("\\%sTok{%s}", textok, tex_replace(txt))
  }
}
