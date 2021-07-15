# change wd
setwd(rstudioapi::getActiveProject())
setwd("book")
oformat <- "bookdown::pdf_book"
oformat <- "bookdown::gitbook"

# render a chapter or the whole book
browseURL(bookdown::preview_chapter("13_modules.Rmd", output_format=oformat))

# preview = TRUE to run faster, but misses some linking
browseURL(bookdown::render_book("index.Rmd", oformat, preview = FALSE))

# copies dir
R.utils::copyDirectory(
  from = "../docs",
  to = "../inst/book", 
  overwrite = TRUE, 
  recursive = TRUE)
