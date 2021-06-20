
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shinyintro

<!-- badges: start -->
<!-- badges: end -->

This package installs all of the packages you need for Lisa DeBruine’s
course on Building Web Apps with R Shiny. It also gives you local access
to the [book](https://debruine/github.io/shinyintro) and example Shiny
apps.

## Installation

You can install shinyintro with:

``` r
# you may have to install devtools first with 
# install.packages("devtools")

devtools::install_github("debruine/shinyintro")
```

## Functions

Open a local copy of the book:

``` r
shinyintro::book()
```

Open a built-in shiny app.

``` r
shinyintro::app("template")
```
