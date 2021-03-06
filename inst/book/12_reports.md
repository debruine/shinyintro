# Customized reports {#reports}

While the best part of Shiny apps is their interactivity, sometimes your users need to download data, images, or a static report. This section will show you how.

<div class="figure" style="text-align: center">
<iframe src="https://shiny.psy.gla.ac.uk/debruine/reports_demo/?showcase=0" width="100%" height="600px"></iframe>
<p class="caption">(\#fig:reports-demo-app)Reports Demo App</p>
</div>

## Download Data

First, we need to add the appropriate UI to our questionnaire app. Create a new tab called "report_tab" with two `downloadButton()`s, one for the pets data and one for the food data.


```r
report_tab <- tabItem(
  tabName = "report_tab",
  box(
    id = "download_box",
    title = "Downloads",
    solidHeader = TRUE,
    downloadButton("pet_data_dl", "Pets Data"),
    downloadButton("food_data_dl", "Food Data")
  )
)
```

::: {.warning}
Remember to add this to `tabItems()` in `dashboardBody()` and also add a corresponding `menuItem()` in `sidebarMenu()`. Run the app to make sure the UI looks like you expect before you proceed.
:::

Now we need to add code to `server()` to handle the downloads. `downloadButton()` is a special type of output that is handled by `downloadHandler()`. This function takes two arguments, a function to create the filename and a function to create the content. 


```r
### pet_data_dl ----
output$pet_data_dl <- downloadHandler(
  filename = function() {
    debug_msg("pet_data_dl")
    paste0("pet-data_", Sys.Date(), ".csv")
  },
  content = function(file) {
    gs4_write_csv(v$pet_summary_data, file)
  }
)
```

::: {.warning}
Instead of `write.csv()` or `readr::write_csv()`, here we're using `gs4_write_csv()` (defined in `scripts/gs4.R`) because googlesheets can return list columns that cause errors when [saving to CSV](#gs4_save) without some preprocessing.
:::


## Download Images

Now that we need to use the summary plot in more than one place, it doesn't make sense to build it twice. Move all of the code from the `renderPlot()` for `output$pet_summary` into a `reactive()` called `pet_summary_plot`. Then we can build the plot whenever the inputs change and refer to it anywhere as `pet_summary_plot()`.


```r
### pet_summary_plot ----
pet_summary_plot <- reactive({ debug_msg("pet_summary_plot")
  # code from output$pet_summary ...
})

### pet_summary ----
output$pet_summary <- renderPlot({ debug_msg("pet_summary")
    pet_summary_plot()
})
```

The `downloadHandler()` works the same as for downloading a CSV file. You can use `ggsave()` to write the plot. 


```r
# pet_plot_dl ----
output$pet_plot_dl <- downloadHandler(
  filename = function() {
    paste0("pet-plot_", Sys.Date(), ".png")
  },
  content = function(file) {
    ggsave(file,
           pet_summary_plot(),
           width = 7,
           height = 5)
  }
)
```

::: {.try}
Add numeric inputs to the UI to let the user specify the downloaded plot width and height.


<div class='webex-solution'><button>Solution</button>


```r
# add to report_tab ui
numericInput("plot_width", "Plot Width (inches)", 7, min = 1, max = 10)
numericInput("plot_height", "Plot Height (inches)", 5, min = 1, max = 10)

### pet_plot_dl ----
output$pet_plot_dl <- downloadHandler(
  filename = function() {
    debug_msg("pet_plot_dl")
    paste0("pet-plot_", Sys.Date(), ".png")
  },
  content = function(file) {
    ggsave(
      file,
      pet_summary_plot(),
      width = input$plot_width,
      height = input$plot_height
    )
  }
)
```

</div>

:::


## R Markdown

You can render an <a class='glossary' target='_blank' title='The R-specific version of markdown: a way to specify formatting, such as headers, paragraphs, lists, bolding, and links, as well as code blocks and inline code.' href='https://psyteachr.github.io/glossary/r#r-markdown'>R Markdown</a> report for users to download.

First, you need to save an R Markdown file (save the one below as `reports/pet_report.Rmd`). The file will have access to any <a class='glossary' target='_blank' title='A word that identifies and stores the value of some data for later use.' href='https://psyteachr.github.io/glossary/o#object'>objects</a> that are available in `server()`, so you don't have to re-download the summary data and re-create the plot.

````
---
title: "Pet Report"
date: "16 July, 2021" 
output: html_document
---


```r
n_responses <- nrow(v$pet_summary_data)

n_sessions <- v$pet_summary_data$session_id %>%
  unique() %>%
  length()
```
We asked people to rate how much they like pets. We have obtained `r n_responses` responses from `r n_sessions` unique sessions.

## Summary Plot

```r
pet_summary_plot()
```

````

The `content` function uses `rmarkdown::render()` to create the output file from Rmd. We are using `html_document` as the output type, but you can also render as a PDF or Word document if you have <a class='glossary' target='_blank' title='A universal document convertor, used by R to make PDF or Word documents from R Markdown' href='https://psyteachr.github.io/glossary/p#pandoc'>pandoc</a> or <a class='glossary' target='_blank' title='A typesetting program needed to create PDF files from R Markdown documents.' href='https://psyteachr.github.io/glossary/l#latex'>latex</a> installed.


```r
### pet_report_dl ----
output$pet_report_dl <- downloadHandler(
  filename = function() {
    debug_msg("pet_report_dl")
    paste0("pet-report_", Sys.Date(), ".html")
  },
  content = function(file) {
    rmarkdown::render("reports/pet_report.Rmd",
                      output_file = file, 
                      intermediates_dir = tempdir())
  }
)
```

::: {.error}
On your own computer, you don't need to set `intermediates_dir = tempdir()`, but you will need to do this if you want to deploy your app on a shiny server. When rmarkdown renders an Rmd file, it creates several intermediate files in the working directory and then deletes them. you have permission to write to the app's working directory on your own computer, but might not on a shiny server. `tempdir()` is almost always a safe place to write temporary files to.
:::


## Exercises {#exercises-reports}

### Food Data

Create a button that downloads the food data.


<div class='webex-solution'><button>Solution</button>


```r
# add to report_tab ui ----
downloadButton("food_data_dl", "Food Data")

### food_data_dl ----
output$food_data_dl <- downloadHandler(
  filename = function() {
    debug_msg("food_data_dl")
    paste0("food-data_", Sys.Date(), ".csv")
  },
  content = function(file) {
    gs4_write_csv(v$food_summary_data, file)
  }
)
```

</div>


### Food Image

Create a button that downloads the food summary plot


<div class='webex-solution'><button>Solution</button>


```r
# add to report_tab ui ----
downloadButton("food_plot_dl", "Food Plot")

### food_summary_plot ----
food_summary_plot <- reactive({ debug_msg("food_summary_plot")
  # code from output$food_summary ...
})

### food_summary ----
output$food_summary <- renderPlot({ debug_msg("food_summary")
  food_summary_plot()
})

### food_plot_dl ----
output$food_plot_dl <- downloadHandler(
  filename = function() {
    debug_msg("food_plot_dl")
    paste0("food-plot_", Sys.Date(), ".png")
  },
  content = function(file) {
    ggsave(
      file,
      food_summary_plot(),
      width = input$plot_width,
      height = input$plot_height
    )
  }
)
```

</div>


### Food Report

Create a downloadable report for the food data.


<div class='webex-solution'><button>Solution</button>

Don't forget to create an Rmd file with the contents of your food report.


```r
# add to report_tab ui ----
downloadButton("food_report_dl", "Food Report")

### food_report_dl ----
output$food_report_dl <- downloadHandler(
  filename = function() {
    debug_msg("food_report_dl")
    paste0("food-report_", Sys.Date(), ".html")
  },
  content = function(file) {
    rmarkdown::render("reports/food_report.Rmd",
                      output_file = file,
                      intermediates_dir = tempdir())
  }
)
```

</div>


