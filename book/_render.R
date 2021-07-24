# change wd
setwd(rstudioapi::getActiveProject())
setwd("book")
preview <- FALSE # preview = TRUE to run faster, but misses some linking

# render a chapter quickly
#browseURL(bookdown::preview_chapter("05_reactive.Rmd"), preview = TRUE)


# make PDF
browseURL(bookdown::render_book("index.Rmd", "bookdown::pdf_book", preview = preview))
file.remove("../docs/shinyintro.pdf")
file.rename("../docs/_main.pdf", "../docs/shinyintro.pdf")

# make EPUB
bookdown::render_book("index.Rmd", "bookdown::epub_book", preview = preview)
file.remove("../docs/shinyintro.epub")
file.rename("../docs/_main.epub", "../docs/shinyintro.epub")

# make MOBI
file.remove("../docs/shinyintro.mobi")
system("/Applications/calibre.app/Contents/MacOS/ebook-convert ~/rproj/debruine/shinyintro/docs/shinyintro.epub ~/rproj/debruine/shinyintro/docs/shinyintro.mobi")

# make HTML
browseURL(bookdown::render_book("index.Rmd", "bookdown::gitbook", preview = preview))

# copies dir
R.utils::copyDirectory(
  from = "../docs",
  to = "../inst/book", 
  overwrite = TRUE, 
  recursive = TRUE)
