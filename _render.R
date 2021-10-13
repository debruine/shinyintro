# render the book as HTML and open in a browser
xfun::in_dir("book", bookdown::render_book("index.Rmd", "bookdown::bs4_book"))
browseURL("docs/index.html")



# webexercises render oddly in PDFs
# verbatim code chunk headers don't render
xfun::in_dir("book", bookdown::render_book("index.Rmd", "bookdown::pdf_book"))
file.rename("docs/_main.pdf", "docs/shinyintro.pdf")
browseURL("docs/shinyintro.pdf")

# webexercises aren't interactive in epubs
xfun::in_dir("book", bookdown::render_book("index.Rmd", "bookdown::epub_book"))
file.remove("docs/shinyintro.epub")
file.rename("docs/_main.epub", "docs/shinyintro.epub")
browseURL("docs/shinyintro.epub")

# make MOBI version
epub <- file.path(getwd(), "docs/shinyintro.epub")
# requires the command line tools from calibre
ebook_convert <- "/Applications/calibre.app/Contents/MacOS/ebook-convert"
if (file.exists(epub) & file.exists(ebook_convert)) {
  mobi <- gsub(".epub$", ".mobi", epub)
  if (file.exists(mobi)) file.remove(mobi)
  system(paste(ebook_convert, epub, mobi))
}


# copies dir
R.utils::copyDirectory(
  from = "docs",
  to = "inst/book", 
  overwrite = TRUE, 
  recursive = TRUE)
