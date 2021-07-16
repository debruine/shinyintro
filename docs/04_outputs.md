# Outputs {#outputa}

Output are ways that the Shiny app can dynamically display information to the user. In the user interface (<a class='glossary' target='_blank' title='The User Interface. This usually refers to a Shiny App as the user will see it.' href='https://psyteachr.github.io/glossary/u#ui'>UI</a>), you create outputs with IDs that you reference in an associated rendering function inside the <a class='glossary' target='_blank' title='This is the part of a Shiny app that works with logic.' href='https://psyteachr.github.io/glossary/s#server'>server</a> function.

Explore some different output types in the embedded app below before you read about how to set up each type. You can run this app locally with `shinyintro::app("output_demo")` or view it in a separate tab with the [showcase interface](<https://shiny.psy.gla.ac.uk/debruine/output_demo/({target="_blank"}.

<div class="figure" style="text-align: center">
<iframe src="https://shiny.psy.gla.ac.uk/debruine/output_demo/?showcase=0" width="100%" height="800px"></iframe>
<p class="caption">(\#fig:output-demo-app)Output Demo App</p>
</div>

### textOutput

The function `textOutput()` defaults to text inside a `<span>` or `<div>` element, but you can use a different element with the `container` argument.


```r
# in the UI
textOutput("demo_text", container = tags$h3)

# in the server function
output$demo_text <- renderText({
    sprintf("Plot of %s", input$y)
})
```

If you use `verbatimTextOutput()` in the UI (no change to the server function), it will show the output in a fixed-width font. This can be good for code or text you want the user to copy.


```r
# in the UI
verbatimTextOutput("demo_verbatim")

# in the server function
output$demo_verbatim <- renderText({
        code <- 
"ggplot(iris, aes(x = Species, y = %s, color = Species)) +
    geom_violin(show.legend = FALSE) +
    stat_summary(show.legend = FALSE)"
        
        sprintf(code, input$y)
    })
```

### uiOutput

If you want to dynamically create parts of the UI, you can use `uiOutput()`. You can create the UI using the [input functions](#input_functions)


```r
# in the UI
uiOutput("demo_ui")

# in the server function
output$demo_ui <- renderUI({
  cols <- names(iris)[1:4]
  selectInput("y", "Column to plot", cols, "Sepal.Length")
})
```

::: {.info}
The function `htmlOutput()` is exactly the same as `uiOutput()`, so you might see that in some code examples, but I use `uiOutput()` to make the connection with `renderUI()` clearer, since there is no `renderHTML()`.
:::



### plotOutput


```r
# in the UI
plotOutput("demo_plot")

# in the server function
output$demo_plot <- renderPlot({
  ggplot(iris, aes(x = Species, y = .data[[input$y]], color = Species)) +
    geom_violin(show.legend = FALSE) +
    stat_summary(show.legend = FALSE) +
    ylab(input$y)
})
```

::: {.warning}
If you want to create dynamic plots that change with input, note how you need to use `y = .data[[input$y]]` inside `aes()`, instead of just `y = input$y`.
:::

### imageOutput


```r
# in the UI
imageOutput("demo_image")

# in the server function
output$demo_image <- renderImage({
    list(src = "images/flower.jpg",
         width = 100,
         height = 100,
         alt = "A flower")
}, deleteFile = FALSE)
```

You can dynamically display images of any type, but one of the most useful ways to use image outputs is to control the aspect ratio and relative size of plots. When you save a temporary file, you should set `deleteFile = TRUE` in `renderImage()` (this stops unneeded plots using memory).


```r
# in the UI
imageOutput("demo_image")

# in the server function
output$demo_image <- renderImage({
  # make the plot
  g <- ggplot(iris, aes(x = Species, y = .data[[input$y]], color = Species)) +
    geom_violin(show.legend = FALSE) +
    stat_summary(show.legend = FALSE) +
    ylab(input$y)
  
  # save to a temporary file
  plot_file <- tempfile(fileext = ".png")

  ggsave(plot_file, demo_plot(), units = "in",
         dpi = 72, width = 7, height = 5)
    
  # Return a list containing the filename
  list(src = plot_file,
       width = "100%", # don't set the height to keep aspect ratio
       alt = "The plot")
}, deleteFile = TRUE)
```

### tableOutput

Display a table using `renderTable()`, which makes a table out of any data frame it returns.


```r
# in the UI
tableOutput("demo_table")

# in the server function
output$demo_table <- renderTable({
  iris %>%
    group_by(Species) %>%
    summarise(mean = mean(.data[[input$y]]),
              sd = sd(.data[[input$y]]))
})
```

::: {.warning}
Note how you need to use `.data[[input$y]]` inside `dplyr::summarise()`, instead of just `input$y` to dynamically choose which variable to summarise.
:::

### dataTableOutput

If you have a long table to show, or one that you want users to be able to sort or search, use `dataTableOutput()`. You can customise data tables in many ways, but we'll stick with a basic example here.


```r
# in the UI
DT::dataTableOutput("demo_datatable")

# in the server function
output$demo_datatable <- DT::renderDataTable({
    iris
}, options = list(pageLength = 10))
```

::: {.warning}
The basic `shiny` package has `dataTableOutput()` and `renderDataTable()` functions, but they can be buggy. The versions in the `DT` package are better and have some additional functions, so I use those.
:::

