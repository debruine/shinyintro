# Shiny modules for repeated structures {#modules}

If you find yourself making nearly identical <a class='glossary' target='_blank' title='The User Interface. This usually refers to a Shiny App as the user will see it.' href='https://psyteachr.github.io/glossary/u#ui'>UIs</a> or server functions over and over in the same app, you might benefit from modules. This is a way to define a pattern to use repeatedly.

<div class="figure" style="text-align: center">
<iframe src="https://shiny.psy.gla.ac.uk/debruine/modules_demo/?showcase=0" width="100%" height="800px"></iframe>
<p class="caption">(\#fig:modules-demo-app)Modules Demo App</p>
</div>

Run locally with `shinyintro::app("modules_demo")` or view it in a separate tab with the [showcase interface](https://shiny.psy.gla.ac.uk/debruine/modules_demo/){target=\"_blank\"}.

## Modularizing the UI

The two tabPanels below follow nearly identical patterns. You can often identify a place where modules might be useful when you use a naming convention like {base}_{type} for the ids. 


```r
iris_tab <- tabPanel(
  "iris",
  selectInput("iris_dv", "DV", choices = names(iris)[1:4]),
  plotOutput("iris_plot"),
  DT::dataTableOutput("iris_table")
)

mtcars_tab <- tabPanel(
  "mtcars",
  selectInput("mtcars_dv", "DV", choices = c("mpg", "disp", "hp", "drat")),
  plotOutput("mtcars_plot"),
  DT::dataTableOutput("mtcars_table")
)
```

The first step in modularising your code is to make a function that creates the UIs above from the base ID and any other changing aspects. In the example above, the choices are different for each selectInput, so we'll make a function that has the arguments `id` and `choices`.

The first line of a UI module function is always `ns <- NS(id)`, which creates a shorthand way to add the base id to the id type. So instead of the selectInput's name being "iris_dv" or "mtcars_dv", we set it as `ns("dv")`. All ids need to use `ns()` to add the namespace to thier ID.


```r
tabPanelUI <- function(id, choices) {
    ns <- NS(id)
    
    tabPanel(
        id,
        selectInput(ns("dv"), "DV", choices = choices),
        plotOutput(ns("plot")),
        DT::dataTableOutput(ns("table"))
    )
}
```

Now, you can replace two tabPanel definitions with just the following code.


```r
iris_tab <- tabPanelUI("iris", names(iris)[1:4])
mtcars_tab <- tabPanelUI("mtcars", c("mpg", "disp", "hp", "drat"))
```


## Modularizing server functions

In our original code, we have four functions that create the two output tables and two output plots, but these are also largely redundant.


```r
output$iris_table <- DT::renderDataTable({
    iris
})

output$iris_plot <- renderPlot({
    ggplot(iris, aes(x = Species, 
                     y = .data[[input$iris_dv]],
                     fill = Species)) +
        geom_violin(alpha = 0.5, show.legend = FALSE) +
        scale_fill_viridis_d()
})

output$mtcars_table <- DT::renderDataTable({
    mtcars
})

output$mtcars_plot <- renderPlot({
    # handle non-string grouping
    mtcars$vs <- factor(mtcars$vs)
    ggplot(mtcars, aes(x = vs, 
                     y = .data[[input$mtcars_dv]],
                     fill = vs)) +
        geom_violin(alpha = 0.5, show.legend = FALSE) +
        scale_fill_viridis_d()
})
```


The second step to modularising code is creating a server function. You can put all the functions the relate to the inputs and outputs in the UI function here, so we will include one to make the output table and one to make the output plot.

The server function takes the base id as the first argument, and then any arguments you need to specify things that change between base implementations. Above, the tables show different data and the plots use different groupings for the x axis and fill, so we'll add arguments for `data` and `group_by`.

A server function **always** contains `moduleServer()` set up like below.


```r
tabPanelServer <- function(id, data, group_by) {
    moduleServer(id, function(input, output, session) {
      # code ...
    })
}
```

No you can copy in one set of server functions above, remove the base name (e.g., "iris_" or "mtcars_") from and inputs or outputs, and replace specific instances of the data or grouping columns with `data` and `group_by`.


```r
tabPanelServer <- function(id, data, group_by) {
    moduleServer(id, function(input, output, session) {
        output$table <- DT::renderDataTable({
            data
        })
        
        output$plot <- renderPlot({
            # handle non-string groupings
            data[[group_by]] <- factor(data[[group_by]])
            ggplot(data, aes(x = .data[[group_by]], 
                             y = .data[[input$dv]],
                             fill = .data[[group_by]])) +
                geom_violin(alpha = 0.5, show.legend = FALSE) +
                scale_fill_viridis_d()
        })
    })
}
```

::: {.warning}
In the original code, the grouping variables were unquoted, but it's tricky to pass unquoted variable names to custom functions, and we already know how to refer to columns by a character object using `.data[[char_obj]]`. 

The grouping column `Species` in `iris` is already a factor, but recasting it as a factor won't hurt, and is required for the `mtcars` grouping column `vs`.
:::

Now, you can replace the four functions inside the server function with these two lines of code.


```r
tabPanelServer("iris", data = iris, group_by = "Species")
tabPanelServer("mtcars", data = mtcars, group_by = "vs")
```

Our example only reduced our code by 4 lines, but it can save a lot of time, effort, and debugging on projects with many similar modules. For example, if you want to change the plots in your app to use a different geom, now you only have to change one function instead of two.


## Exercises {#exercises-modules}

### 1. Repeat Example

Try to implement the code above on your own.

* Clone "no_modules_demo" `shinyintro::clone("no_modules_demo")`
* Run the app and see how it works
* Create the UI module function and use it to replace `iris_tab` and `mtcars_tab`
* Create the server function and use it to replace the server functions

### 2. New Instance

Add a new tab called "diamonds" that visualises the `diamonds` dataset. Choose the columns you want as choices in the `selectInput()` and the grouping column.


<div class='webex-solution'><button>UI Solution</button>


You can choose any of the numeric columns for the choices.


```r
diamonds_tab <- tabPanelUI("diamonds", c("carat", "depth", "table", "price"))
```

</div>



<div class='webex-solution'><button>Server Solution</button>


You can group by any of the categorical columns: cut, color, or clarity.


```r
tabPanelServer("diamonds", data = diamonds, group_by = "cut")
```

</div>


### 3. Altering modules

* Add another `selectInput()` to the UI that allows the user to select the grouping variable. (`iris` only has one possibility, but `mtcars` and `diamonds` should have several)


<div class='webex-solution'><button>UI Solution</button>


You need to add a new selectInput() to the tabPanel. Remember to use `ns()` for the id. The choices for this select will also differ by data set, so you need to add `group_choices` to the arguments of this function.

 
 ```r
 tabPanelUI <- function(id, choices, group_choices) {
    ns <- NS(id)
    
    tabPanel(
        id,
        selectInput(ns("dv"), "DV", choices = choices),
        selectInput(ns("group_by"), "Group By", choices = group_choices),
        plotOutput(ns("plot")),
        DT::dataTableOutput(ns("table"))
    )
 }
 ```

</div>


* Update the plot function to use the value of this new input instead of "Species", "vs", and whatever you chose for `diamonds`.


<div class='webex-solution'><button>Server Solution</button>


You no longer need `group_by` in the arguments for this function because you are getting that info from an input.

Instead of changing `group_by` to `input$group_by` in three places in the code below, I just added the line `group_by <- input$group_by` at the top of `moduleServer()`.


```r
tabPanelServer <- function(id, data) {
    moduleServer(id, function(input, output, session) {
        group_by <- input$group_by
      
        # rest of the code is the same ...
    })
}
```

</div>


### 4. New module

There is a fluidRow() before the tabsetPanel() in the ui that contains three `infoBoxOutput()` and three renderInfoBoxOutput() functions in the server function.

Modularise the info boxes and their associated server functions. 


<div class='webex-solution'><button>UI Function</button>



```r
infoBoxUI <- function(id, width = 4) {
    ns <- NS(id)

    infoBoxOutput(ns("box"), width)
}
```

</div>



<div class='webex-solution'><button>Server Function</button>



```r
infoBoxServer <- function(id, title, fmt, icon, color = "purple") {
    moduleServer(id, function(input, output, session) {
        output$box <- renderInfoBox({
            infoBox(title = title,
                    value = format(Sys.Date(), fmt),
                    icon = icon(icon),
                    color = color)
        })
    })
}
```

</div>



<div class='webex-solution'><button>UI Code</button>


In the `ui`, replace the `fluidRow()` with this:


```r
fluidRow(
    infoBoxUI("day"),
    infoBoxUI("month"),
    infoBoxUI("year")
)
```

</div>




<div class='webex-solution'><button>Server Code</button>


In `server()`, replace `renderInfoBox()` with this:


```r
infoBoxServer("year", "Year", "%Y", "calendar")
infoBoxServer("month", "Month", "%m", "calendar-alt")
infoBoxServer("day", "Day", "%d", "calendar-day"))
```

</div>

