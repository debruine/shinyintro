# book-specific code to include on every page
suppressPackageStartupMessages({
  library(shiny)
  library(shinydashboard)
  library(formatR)
})

pandoc_to <- knitr::opts_knit$get("rmarkdown.pandoc.to")
is_html <- pandoc_to == "html"
is_epub <- substr(pandoc_to, 1, 4) == "epub"
is_latex <- pandoc_to == "latex"

code_width <- switch(pandoc_to, html = 80, epub3 = 35, latex = 80)

knitr::opts_chunk$set(
  warning = FALSE,
  message = FALSE,
  tidy.opts=list(width.cutoff=code_width), 
  tidy=FALSE
)

theme_set(theme_minimal())



tex_replace <- function(txt) {
  for (char in c("#", "_", " ", "$", "{", "}")) {
    txt <- gsub(char, paste0("\\", char), txt, fixed = TRUE)
  }
  txt
}

path <- function(txt) {
  if (is_latex) {
    sprintf("\\textit{\\texttt{%s}}", tex_replace(txt))
  } else {
    sprintf("<code class='path'>%s</code>", txt)
  }
}

pkg <- function(txt) {
  if (is_latex) {
    sprintf("\\textbf{\\texttt{%s}}", tex_replace(txt))
  } else {
    sprintf("<code class='package'>%s</code>", txt)
  }
}


func <- function(txt, args = "") {
  if (is_latex) {
    sprintf("\\texttt{%s}\\texttt{(%s)}", tex_replace(txt), tex_replace(args))
  } else {
    sprintf("<code><span class='fu'>%s</span>(%s)</code>", txt, args)
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
  
  if (is_latex) {
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
  } else {
    if (class == "st") txt <- sprintf("&quot;%s&quot;", txt)
    txt <- gsub("<", "&lt;", txt, fixed = TRUE)
    sprintf("<code><span class='%s'>%s</span></code>", class, txt)
  }
}
