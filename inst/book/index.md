--- 
title: "Building Web Apps with R Shiny"
author: "Lisa DeBruine"
date: "2021-06-20"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
description: "This class will teach you the basics of Shiny app programming, giving you skills that will form the basis of almost any app you want to build. By the end of the class, you will have created a custom app that collects and saves data, allows users to dynamically visualize the data, and produces downloadable reports."
---




# Overview {-}

<a class='glossary' target='_blank' title='An R package that builds interactive web apps' href='https://psyteachr.github.io/glossary/s#shiny'>Shiny</a> apps let you make web applications that do anything you can code in R. For example, you can share your data analysis in a dynamic way with people who don’t use R, collect and visualize data, or even make data aRt.

While there is a wealth of material available on the internet to help you get started with Shiny, it can be difficult to see how everything fits together. This class will take a predominantly live coding approach, rather than a lecture-only approach, so you can code along with the instructor and deal with the inevitable bugs and roadblocks together.

This class will teach you the basics of Shiny app programming, giving you skills that will form the basis of almost any app you want to build. By the end of the class, you will have created a custom app that collects and saves data, allows users to dynamically visualize the data, and produces downloadable reports.

## Example Apps

The following are some diverse examples of Shiny apps that the instructor has made.

* [Word Cloud](https://shiny.psy.gla.ac.uk/debruine/wordcloud/){target="_blank"} Create a word cloud from text and customize its appearance. Created during the live-coding event at [Hack Your Data Beautiful](https://psyteachr.github.io/hack-your-data/){target="_blank"}.
* [Plot Demo](https://shiny.psy.gla.ac.uk/debruine/plotdemo/){target="_blank"} Simulate data from a 2×2 factorial design and visualize it with 6 different plot styles.
* [Simulating for LMEM](https://shiny.psy.gla.ac.uk/lmem_sim/){target="_blank"} companion to Understanding mixed effects models through data simulation (DeBruine & Barr, AMPPS 2021)
* [Scienceverse](http://shiny.ieis.tue.nl/scienceverse/){target="_blank"} is an ambitious (but in-progress) app for creating machine-readable descriptions of studies and human-readable summaries.

## Code Horizons Course (27-30 July 2021)

Starting July 27, we are offering this seminar as a 4-day synchronous*, remote workshop for the first time. Each day will consist of a 3-hour live lecture held via the free video-conferencing software Zoom. You are encouraged to join the lecture live, but will have the opportunity to view the recorded session later if you are unable to attend at the scheduled time.

Each lecture session will conclude with a hands-on exercise reviewing the content covered, to be completed on your own. An additional lab session will be held Tuesday and Thursday afternoons, where you can review the exercise results with the instructor and ask any questions.

We understand that scheduling is difficult during this unpredictable time. If you prefer, you may take all or part of the course asynchronously. The video recordings will be made available within 24 hours of each session and will be accessible for two weeks after the seminar, meaning that you will get all of the class content and discussions even if you cannot participate synchronously.

Closed captioning is available for all live and recorded sessions.


## Computing

To participate in the hands-on exercises, you are strongly encouraged to use a computer with the most recent version of [R installed](https://www.r-project.org/){target="_blank"}. Participants are also encouraged to download and install [RStudio](https://www.rstudio.com/products/rstudio/download/){target="_blank"}, a front-end for R that makes it easier to work with. This software is free and available for Windows, Mac, and Linux platforms.

## Who Should Register?

You need to have basic familiarity with R, including data import, <a class='glossary' target='_blank' title='The process of preparing data for visualisation and statistical analysis.' href='https://psyteachr.github.io/glossary/d#data-wrangling'>data processing</a>, visualization, and <a class='glossary' target='_blank' title='A named section of code that can be reused.' href='https://psyteachr.github.io/glossary/f#function'>functions</a> and control structures (e.g., if/else). Instruction will be done using <a class='glossary' target='_blank' title='An integrated development environment (IDE) that helps you process R code.' href='https://psyteachr.github.io/glossary/r#rstudio'>RStudio</a>. Some familiarity with ggplot2 and dplyr would be useful. You definitely do not need to be an expert coder, but the following code should not be challenging to understand.


```r
library(ggplot2)

pets <- read.csv("pets.csv")

dv <- sample(c("score", "weight"), 1)

if (dv == "score") {
  g <- ggplot(pets, aes(pet, score, fill = country))
} else if (dv == "weight") {
  g <- ggplot(pets, aes(pet, weight, fill = country))
}

r + geom_violin(alpha = 0.5)
```


If you want to brush up on your R (especially <a class='glossary' target='_blank' title='A set of R packages that help you create and work with tidy data' href='https://psyteachr.github.io/glossary/t#tidyverse'>tidyverse</a>), and also gain familiarity with the instructor's teaching style, the first seven chapters of [Data Skills for Reproducible Science](https://psyteachr.github.io/msc-data-skills/){target="_blank"} provide a good overview.


## Glossary {#glossary-intro}


|term                                                                                                                |definition                                                                 |
|:-------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------|
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/d#data-wrangling'>data-wrangling</a> |The process of preparing data for visualisation and statistical analysis.  |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/f#function'>function</a>             |A named section of code that can be reused.                                |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/r#rstudio'>rstudio</a>               |An integrated development environment (IDE) that helps you process R code. |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/s#shiny'>shiny</a>                   |An R package that builds interactive web apps                              |
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/t#tidyverse'>tidyverse</a>           |A set of R packages that help you create and work with tidy data           |

