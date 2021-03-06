# Reactive functions {#reactives}

There are a lot of great tutorials that explain the principles behind reactive functions, but that never made any sense to me when I first started out, so I'm just going to give you examples that you can extrapolate principles from.

Reactivity is how Shiny determines which code in `server()` gets to run when. Some types of <a class='glossary' target='_blank' title='A word that identifies and stores the value of some data for later use.' href='https://psyteachr.github.io/glossary/o#object'>objects</a>, such as the `input` object or objects made by `reactiveValues()`, can trigger some types of functions to run whenever they change. 

For our example, we will use the `reactive_demo` app. It shows three select inputs that allow the user to choose values from the cut, color, and clarity columns of the `diamonds` dataset from ggplot2, then draws a plot of the relationship between carat and price for the selected subset.

<div class="figure" style="text-align: center">
<iframe src="https://shiny.psy.gla.ac.uk/debruine/reactive_demo/?showcase=0" width="100%" height="800px"></iframe>
<p class="caption">(\#fig:reactive-demo-app)Reactive Demo App</p>
</div>

Here is the relevant code for the UI. There are four inputs: cut, color, clarity, and update. There are two outputs: title and plot.


```r
box(
  title = "Diamonds",
  solidHeader = TRUE,
  selectInput("cut", "Cut", levels(diamonds$cut)),
  selectInput("color", "Color", levels(diamonds$color)),
  selectInput("clarity", "Clarity", levels(diamonds$clarity)),
  actionButton("update", "Update Plot")
),
box(
  title = "Plot",
  solidHeader = TRUE,
  textOutput("title"),
  plotOutput("plot")
)
```


Whenever an input changes, it will trigger some types of functions to run.

## observeEvent()

We learned about `observeEvent()` in [Chapter 1](#first-reactive). This function runs the code whenever the value of the first argument changes. If there are reactives inside the function, they won't trigger the code to run when they change.


```r
server <- function(input, output, session) {
  observeEvent(input$update, {
    data <- filter(diamonds,
                   cut == input$cut,
                   color == input$color,
                   clarity == input$clarity)
    
    title <- sprintf("Cut: %s, Color: %s, Clarity: %s",
                     input$cut,
                     input$color,
                     input$clarity)
    
    output$plot <- renderPlot({
      ggplot(data, aes(carat, price)) +
        geom_point(color = "#605CA8", alpha = 0.5) +
        geom_smooth(method = lm, color = "#605CA8")
    })
    
    output$title <- renderText(title)
  })
} 
```

In the example above, which inputs will trigger `renderPlot()` to run and produce a new plot?

<select class='webex-solveme' data-answer='["update","all of the above"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

In the example above, which inputs will trigger `renderText()` to run and produce a new title?

<select class='webex-solveme' data-answer='["update","all of the above"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>


## Render functions

Functions that render an output, like `renderText()` or `renderPlot()` will run whenever an input in their code changes. You can trigger a render function just by putting a reactive alone on a line, even if you aren't using it in the rest of the code.


```r
server <- function(input, output, session) {
  output$plot <- renderPlot({
    data <- filter(diamonds,
                   cut == input$cut,
                   color == input$color,
                   clarity == input$clarity)
    
    ggplot(data, aes(carat, price)) +
      geom_point(color = "#605CA8", alpha = 0.5) +
      geom_smooth(method = lm, color = "#605CA8")
  })
  
  output$title <- renderText{
    input$update 
    
    sprintf("Cut: %s, Color: %s, Clarity: %s",
                     input$cut,
                     input$color,
                     input$clarity)
  })
} 
```

In the example above, which inputs will trigger `renderPlot()` to run and produce a new plot?

<select class='webex-solveme' data-answer='["cut, color & clarity"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

Which inputs will trigger `renderText()` to run and produce a new title?

<select class='webex-solveme' data-answer='["all of the above"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

## reactive()

If you move the `data` filtering outside of `renderPlot()`, you'll get an error message like "Can't access reactive value 'cut' outside of reactive consumer." This means that the `input` values can only be read inside certain functions, like `reactive()`, `observeEvent()`, or a render function.

However, we can put the data filtering inside `reactive()`. This means that whenever an input inside that function changes, the code will run and update the value of `data()`. This can be useful if you need to recalculate the data table each time the inputs change, and then use it in more than one function.


```r
server <- function(input, output, session) {
  data <- reactive({
    filter(diamonds,
           cut == input$cut,
           color == input$color,
           clarity == input$clarity)
  })
  
  title <- reactive({
    sprintf("Cut: %s, Color: %s, Clarity: %s, N: %d",
                     input$cut,
                     input$color,
                     input$clarity,
            nrow(data()))
  })
  
  output$plot <- renderPlot({
    ggplot(data(), aes(carat, price)) +
      geom_point(color = "#605CA8", alpha = 0.5) +
      geom_smooth(method = lm, color = "#605CA8")
  })
  
  output$text <- renderText(title())
} 
```

In the example above, which inputs will trigger `renderPlot()` to run and produce a new plot?

<select class='webex-solveme' data-answer='["cut, color & clarity"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

Which inputs will trigger `renderText()` to run and produce a new title?

<select class='webex-solveme' data-answer='["cut, color & clarity"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

::: {.warning}
My most common error is trying to use `data` or `title` as an object instead of as a function. Notice how the first argument to ggplot is no longer `data`, but `data()` and you set the value of data with `data(newdata)`, not `data <- newdata`. For now, just remember this as a quirk of shiny.
:::

## eventReactive() 

While `reactive()` is triggered whenever any input values inside it change, `eventReactive()` is only triggered when the value of the first argument changes, like `observeEvent()`, but returns a reactive function like `reactive()`.


```r
server <- function(input, output, session) {
  data <- eventReactive(input$update, {
    filter(diamonds,
           cut == input$cut,
           color == input$color,
           clarity == input$clarity)
  })
  
  title <- eventReactive(input$update, {
    sprintf("Cut: %s, Color: %s, Clarity: %s",
                     input$cut,
                     input$color,
                     input$clarity)
  })
  
  output$plot <- renderPlot({
    ggplot(data(), aes(carat, price)) +
      geom_point(color = "#605CA8", alpha = 0.5) +
      geom_smooth(method = lm, color = "#605CA8")
  })
  
  output$text <- renderText(title())
}
```

In the example above, which inputs will trigger `renderPlot()` to run and produce a new plot?

<select class='webex-solveme' data-answer='["update"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

Which inputs will trigger `renderText()` to run and produce a new title?

<select class='webex-solveme' data-answer='["update"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>


## reactiveVal()

Another pattern that accomplishes a similar thing to `reactive()` is to create a reactive value using `reactiveVal()`. This allows you to update the value of `data()` not just using the code inside the `reactive()` function that created it, but in any function. This is useful when you have multiple functions that need to update that value.

Here, we use `observeEvent()` to trigger the data filtering code only when the update button is pressed. This new data set is assigned to `data()` using the code `data(newdata)`. 

Because `data()` is a reactive value, it will trigger `renderPlot()` whenever it changes.


```r
server <- function(input, output, session) {
    data <- reactiveVal(diamonds)
    
    observeEvent(input$update, {
        newdata <- filter(diamonds,
               cut == input$cut,
               color == input$color,
               clarity == input$clarity)
        
        data(newdata) # updates data()
    })
    
    output$plot <- renderPlot({
        ggplot(data(), aes(carat, price)) +
            geom_point(color = "#605CA8", alpha = 0.5) +
            geom_smooth(method = lm, color = "#605CA8")
    })
    
    output$title <- renderText({
      sprintf("Cut: %s, Color: %s, Clarity: %s",
                     input$cut,
                     input$color,
                     input$clarity)
    })
} 
```

In the example above, which inputs will trigger `renderPlot()` to run and produce a new plot?

<select class='webex-solveme' data-answer='["update"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

Which inputs will trigger `renderText()` to run and produce a new title?

<select class='webex-solveme' data-answer='["cut, color & clarity"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

::: {.info}
We used `data <- reactiveVal(diamonds)` in order for `data()` to have a value that didn't cause an error when `renderPlot()` runs for the first time. 
:::

## reactiveValue()

You need to set up a new `reactiveVal()` for each value in an app that you want to make reactive. I prefer to use `reactiveValues()` because it can be used for any new reactive value you need and works just like `input`. 

You can just set your new object to `reactiveValues()` or you can initialise it with starting values like below. The object `v` is a named list, just like `input`, and when it's values change, it triggers reactive functions exactly like `input` does. 


```r
server <- function(input, output, session) {
    v <- reactiveValues(
        data = diamonds,
        title = "All Data"
    )
    
    observeEvent(input$update, {
        v$data <- filter(diamonds,
                       cut == input$cut,
                       color == input$color,
                       clarity == input$clarity)
        
        v$title <- sprintf("Cut: %s, Color: %s, Clarity: %s",
                         input$cut,
                         input$color,
                         input$clarity)
    })
    
    output$plot <- renderPlot({
        ggplot(v$data, aes(carat, price)) +
            geom_point(color = "#605CA8", alpha = 0.5) +
            geom_smooth(method = lm, color = "#605CA8")
    })
    
    output$title <- renderText(v$title)
} 
```

In the example above, which inputs will trigger `renderPlot()` to run and produce a new plot?

<select class='webex-solveme' data-answer='["update"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

Which inputs will trigger `renderText()` to run and produce a new title?

<select class='webex-solveme' data-answer='["update"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

::: {.warning}
Note that you refer to reactive values set up this way as `v$data` and `v$title`, not `data()` and `title()`.
:::

## isolate()

If you want to use an input or reactive value inside a reactive function, but don't want to trigger that function, you can `isolate()` it. You can also use `isolate()` to use a reactive value outside a reactive function.


```r
server <- function(input, output, session) {
  data <- reactive({
    filter(
      diamonds,
      cut == isolate(input$cut),
      color == isolate(input$color),
      clarity == input$clarity
    )
  })
  
  title <- reactive({
    sprintf(
      "Cut: %s, Color: %s, Clarity: %s",
      input$cut,
      isolate(input$color),
      isolate(input$clarity)
    )
  })
  
  # what is the title at initialisation?
  debug_msg(isolate(title()))
  
  output$plot <- renderPlot({
    ggplot(data(), aes(carat, price)) +
      geom_point(color = "#605CA8", alpha = 0.5) +
      geom_smooth(method = lm, color = "#605CA8")
  })
  
  output$title <- renderText(title())
} 
```

In the example above, which inputs will trigger `renderPlot()` to run and produce a new plot?

<select class='webex-solveme' data-answer='["clarity"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>

Which inputs will trigger `renderText()` to run and produce a new title?

<select class='webex-solveme' data-answer='["cut"]'> <option></option> <option>cut</option> <option>color</option> <option>clarity</option> <option>update</option> <option>cut, color & clarity</option> <option>all of the above</option></select>


## Further Resources {#resources-reactive)

* [Reactivity - An overview](https://shiny.rstudio.com/articles/reactivity-overview.html){target="_blank"}
* [ Use reactive expressions ](https://shiny.rstudio.com/tutorial/written-tutorial/lesson6/){target="_blank"}



## Exercises {#exercises-reactive}

For the following exercises, clone "reactive_demo" and replace the boxes in the ui with the code below. Delete all the code in `server()`. Make sure this runs before you go ahead.


```r
box(width = 4,
    selectInput("stat", "Statistic", c("mean", "sd")),
    selectInput("group", "Group By", c("vore", "order", "conservation")),
    actionButton("update", "Update Table")),
box(width = 8,
    solidHeader = TRUE,
    title = textOutput("caption"),
    tableOutput("table"))
```

You will grouping and summarising the `msleep` data table from `ggplot2` by calculating the mean or standard deviation for all (or some) of the numeric columns grouped by the categorical columns vore, order, or conservation. If you're not sure how to create such a summary table with dplyr, look at the following code for a concrete example.


<div class='webex-solution'><button>Hint</button>


```r
msleep %>%
  group_by(vore) %>%
  summarise_if(is.numeric, "mean", na.rm = TRUE)
```

<div class="kable-table">

|vore    | sleep_total| sleep_rem| sleep_cycle|    awake|   brainwt|    bodywt|
|:-------|-----------:|---------:|-----------:|--------:|---------:|---------:|
|carni   |   10.378947|  2.290000|   0.3733333| 13.62632| 0.0792556|  90.75111|
|herbi   |    9.509375|  1.366667|   0.4180556| 14.49062| 0.6215975| 366.87725|
|insecti |   14.940000|  3.525000|   0.1611111|  9.06000| 0.0215500|  12.92160|
|omni    |   10.925000|  1.955556|   0.5924242| 13.07500| 0.1457312|  12.71800|
|NA      |   10.185714|  1.880000|   0.1833333| 13.81429| 0.0076260|   0.85800|

</div>

</div>


### observeEvent

Use `observeEvent()` to update the output table with the appropriate summary table and to update the caption with an appropriate caption only when the update button is clicked.


<div class='webex-solution'><button>Solution</button>


```r
server <- function(input, output, session) {
    observeEvent(input$update, {
        data <- msleep %>%
            group_by(.data[[input$group]]) %>%
            summarise_if(is.numeric, input$stat, na.rm = TRUE)
        output$table <- renderTable(data)
    
        caption <- sprintf("%ss by %s", toupper(input$stat), input$group)
        output$caption <- renderText(caption)
    })
} 
```

</div>


### render

Use render functions to update the output table and caption whenever group or stat change.


<div class='webex-solution'><button>Solution</button>


```r
server <- function(input, output, session) {
    output$table <- renderTable({
        msleep %>%
            group_by(.data[[input$group]]) %>%
            summarise_if(is.numeric, input$stat, na.rm = TRUE)
    })
    
    output$caption <- renderText({
        sprintf("%ss by %s", toupper(input$stat), input$group)
    })
} 
```

</div>


### reactive

Use reactive functions to update the output table and caption whenever group or stat change. Ignore the update button.


<div class='webex-solution'><button>Solution</button>


```r
server <- function(input, output, session) {
  data <- reactive({
    msleep %>%
      group_by(.data[[input$group]]) %>%
      summarise_if(is.numeric, input$stat, na.rm = TRUE)
  })
  output$table <- renderTable(data())
  
  caption <- reactive({
    sprintf("%ss by %s", toupper(input$stat), input$group)
  })
  output$caption <- renderText(caption())
} 
```

</div>


### eventReactive

Use `eventReactive()` to update the output table and caption only when the update button is clicked.


<div class='webex-solution'><button>Solution</button>


```r
server <- function(input, output, session) {
  data <- eventReactive(input$update, {
    msleep %>%
      group_by(.data[[input$group]]) %>%
      summarise_if(is.numeric, input$stat, na.rm = TRUE)
  })
  output$table <- renderTable(data())
  
  caption <- eventReactive(input$update, {
    sprintf("%ss by %s", toupper(input$stat), input$group)
  })
  output$caption <- renderText(caption())
} 
```

</div>



### reactiveVal

Use `reactiveVal()` to update the output table and caption only when the update button is clicked.


<div class='webex-solution'><button>Solution</button>


```r
server <- function(input, output, session) {
  data <- reactiveVal()
  caption <- reactiveVal()
  
  observeEvent(input$update, {
    newdata <- msleep %>%
      group_by(.data[[input$group]]) %>%
      summarise_if(is.numeric, input$stat, na.rm = TRUE)
    data(newdata)
    
    # this is an alternative way to set reactiveVal
    # by piping the value into the function
    sprintf("%ss by %s", toupper(input$stat), input$group) %>%
      caption()
  })
  
  output$table <- renderTable(data())
  output$caption <- renderText(caption())
} 
```

</div>



### reactiveValues

Use `reactiveValues()` to update the output table and caption only when the update button is clicked.


<div class='webex-solution'><button>Solution</button>


```r
server <- function(input, output, session) {
  v <- reactiveValues()
  
  observeEvent(input$update, {
    v$data <- msleep %>%
      group_by(.data[[input$group]]) %>%
      summarise_if(is.numeric, input$stat, na.rm = TRUE)
    
    v$caption <- sprintf("%ss by %s", toupper(input$stat), input$group)
  })
  
  output$table <- renderTable(v$data)
  output$caption <- renderText(v$caption)
} 
```

</div>






