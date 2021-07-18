# change wd
setwd(rstudioapi::getActiveProject())
setwd("book")

# render a chapter or the whole book
browseURL(bookdown::preview_chapter("01_first_app.Rmd"))

browseURL(bookdown::render_book("index.Rmd", "bookdown::pdf_book", preview = FALSE))

file.copy("../docs/_main.pdf", "../docs/shinyintro.pdf")

# preview = TRUE to run faster, but misses some linking
browseURL(bookdown::render_book("index.Rmd", "bookdown::gitbook", preview = FALSE))

# copies dir
R.utils::copyDirectory(
  from = "../docs",
  to = "../inst/book", 
  overwrite = TRUE, 
  recursive = TRUE)
