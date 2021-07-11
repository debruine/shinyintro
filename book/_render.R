# change wd
setwd(rstudioapi::getActiveProject())
setwd("book")

# render a chapter or the whole book
browseURL(bookdown::preview_chapter("03_inputs.Rmd"))

# preview = TRUE to run faster, but misses some linking
browseURL(bookdown::render_book("index.Rmd", preview = FALSE))

# copies dir
R.utils::copyDirectory(
  from = "../docs",
  to = "../inst/book", 
  overwrite = TRUE, 
  recursive = TRUE)
