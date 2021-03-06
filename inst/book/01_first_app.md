# Your First Shiny App {#first-app}

## The Demo App

To start, let's walk through the basics of setting up a <a class='glossary' target='_blank' title='An R package that builds interactive web apps' href='https://psyteachr.github.io/glossary/s#shiny'>shiny</a> app, starting with the example built into <a class='glossary' target='_blank' title='An integrated development environment (IDE) that helps you process R code.' href='https://psyteachr.github.io/glossary/r#rstudio'>RStudio</a> I won't explain yet how shiny apps are structured; the goal is to just get something up and running, and give you some familiarity with the layout of a fairly simple app.

### Set Up the Demo App

<div class="figure" style="text-align: center">
<img src="images/demo_app/01-create-project.png" alt="Creating a demo app." width="30%" /><img src="images/demo_app/02-project-type.png" alt="Creating a demo app." width="30%" /><img src="images/demo_app/03-project-directory.png" alt="Creating a demo app." width="30%" />
<p class="caption">(\#fig:first-demo)Creating a demo app.</p>
</div>

1.  Under the `File` menu, choose `New Project...`. You will see a popup window like the one above. Choose `New Directory`.

2.  Choose `Shiny Web Application` as the project type.

3.  I like to put all of my apps in the same <a class='glossary' target='_blank' title='A collection or “folder” of files on a computer.' href='https://psyteachr.github.io/glossary/d#directory'>directory</a>, but it doesn't matter where you save it.

4.  Your RStudio interface should look like this now. You don't have to do anything else at this step.

![](images/demo_app/04-rstudio-interface.png)

::: {.warning}
If RStudio has changed their demo app and your source code doesn't look like this, replace it with the code below:


<div class='webex-solution'><button>View Code</button>



```r
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)
```


</div>

:::

Click on `Run App` in the top right corner of the <a class='glossary' target='_blank' title='RStudio is arranged with four window “panes.”' href='https://psyteachr.github.io/glossary/p#panes'>source pane</a>. The app will open up in a new window. Play with the slider and watch the histogram change.

![](images/demo_app/05-app-interface.png)

::: {.info}
You can also open up the app in a web browser by clicking on `Open in Browser`.
:::

### Modify the Demo App

Now we're going to make a series of changes to the demo app until it's all your own.

::: {.info}
You can close the app by closing the window or browser tab it's running in, or leave it running while you edit the code. If you have multiple screens, it's useful to have the app open on one screen and the code on another.
:::

Find the application title. It is the first [argument](defs.html#argument) to the [function](defs.html#function) `titlePanel`. Change the title to `"My First App"`. Make sure the title is inside quotes and the whole quoted <a class='glossary' target='_blank' title='A piece of text inside of quotes.' href='https://psyteachr.github.io/glossary/s#string'>string</a> is inside the parentheses. Save the file (`cmd-S` or `File > Save`).

![](images/demo_app/06-change-title.png)

Click `Run App` (or `Reload App` if you haven't closed the app window) in the [source pane](defs.html#panes). If you haven't saved your changes, it will prompt you to do so. Check that the app title has changed.

Now let's change the input. Find the function `sliderInput` (line 21). The first <a class='glossary' target='_blank' title='A variable that provides input to a function.' href='https://psyteachr.github.io/glossary/a#argument'>argument</a> is the name you can use in the code to find the value of this input, so don't change it just yet. The second argument is the text that displays before the slider. Change this to something else and re-run the app.


```r
         sliderInput("bins",
                     "Number of bins:",
                     min = 0,
                     max = 50,
                     value = 30)
```

::: {.try}
See if you can figure out what the next three arguments to `sliderInput` do. Change them to different <a class='glossary' target='_blank' title='A data type representing whole numbers.' href='https://psyteachr.github.io/glossary/i#integer'>integers</a>, then re-run the app to see what's changed.
:::

The arguments to the function `sidebarPanel` are just a list of things you want to display in the sidebar. To add some explanatory text in a paragraph before the `sliderInput`, just use the paragraph function `p("My text")`


```r
      sidebarPanel(
         p("I am explaining this perfectly"),
         sliderInput("bins",
                     "Choose the best bin number:",
                     min = 10,
                     max = 40,
                     value = 25)
      )
```

![](images/demo_app/07-app-sidebar-p.png)

::: {.info}
The sidebar shows up on the left if your window is wide enough, but moves to the top of the screen if it's too narrow.
:::

I don't like it there, so we can move this text out of the sidebar and to the top of the page, just under the title. Try this and re-run the app.


```r
   # Application title
   titlePanel("My First App"),

   p("I am explaining this perfectly"),

   # Sidebar with a slider input for number of bins
   sidebarLayout(...)
```

::: {.try}
See where you can move the text in the layout of the page and where causes errors.
:::

I'm also not keen on the grey plot. We can change the plot colour inside the `hist` function.


```r
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'steelblue3', border = 'grey30')
```

There are a lot of ways to represent colour in R. The easiest three are:

1.  hexadecimal colours like `#0066CC`,
2.  the `rgb` or `hsl` functions,
3.  colour names (type `colours()` in the console)

I like `steelblue3`, as it's pretty close to the shiny interface default colour, but feel free to choose whatever you like.

I prefer `ggplot` graphs, so let's make the plot with `geom_histogram` instead of `hist` (which is a great function for really quick plots). Since we need several functions from the `ggplot2` <a class='glossary' target='_blank' title='A group of R functions.' href='https://psyteachr.github.io/glossary/p#package'>package</a>, we'll need to load that package at the top of the script, just under where the `shiny` package is loaded:


```r
library(shiny)
library(ggplot2)
```

You can replace all of the code in the `renderPlot` function with the code below.


```r
  output$distPlot <- renderPlot({
    # create plot
    ggplot(faithful, aes(waiting)) +
      geom_histogram(bins = input$bins,
                     fill = "steelblue3",
                     colour = "grey30") +
      xlab("What are we even plotting here?") +
      theme_minimal()
  })
```

::: {.info}
You can set the `fill` and `colour` to whatever colours you like, and change `theme_minimal()` to one of the other [built-in ggplot themes](https://ggplot2.tidyverse.org/reference/ggtheme.html#examples){target="_blank"}.
:::

::: {.try}
What *are* we even plotting here? Type `?faithful` into the console pane to see what the `waiting` column represents (`faithful` is a built-in demo dataset). Change the label on the x-axis to something more sensible.
:::

### Add New Things

The `faithful` dataset includes two columns:`eruptions` and `waiting`. We've been plotting the `waiting` variable, but what if you wanted to plot the `eruptions` variable instead?

::: {.try}
Try plotting the eruption time (`eruptions`) instead of the waiting time. You just have to change one word in the `ggplot` function and update the x-axis label.
:::

We can add another input <a class='glossary' target='_blank' title='A interactive web element, like a dropdown menu or a slider.' href='https://psyteachr.github.io/glossary/w#widget'>widget</a> to let the user switch between plotting eruption time and wait time. The [RStudio Shiny tutorial](https://shiny.rstudio.com/tutorial/written-tutorial/lesson3/) has a great overview of the different input options. We need to toggle between two options, so we can use either radio buttons or a select box. Radio buttons are probably best if you have only a few options and the user will want to see them all at the same time to decide.

Add the following code as the first argument to `sidebarPanel()`, which just takes a list of different widgets. `radioButtons` is the widget we're using. The first argument is `display_var`, which we will use later in the code to find the value of this widget. The second argument is the label to display to the user. The next argument is `choices`, which is a list of choices in the format `c("label1" = "value1", "label2 = "value2", ...)`. The label is what gets shown to the user and the value is what gets used by the code (these can be the same, but you often want the user label to be more descriptive). The last argument is `selected`, which is the value of the default choice. Save this and re-run the app.


```r
         radioButtons("display_var",
                      "Which variable to display",
                      choices = c("Waiting time to next eruption" = "waiting",
                                  "Eruption time" = "eruptions"),
                      selected = "waiting"
         ),
```

![](images/demo_app/08-radiobutton-widget.png)

You should have a radio button interface now. You can click on the options to switch the button, but it won't do anything to your plot yet. We need to edit the plot-generating code to make that happen.

First, we need to change the x-axis label depending on what we're graphing. We use an if/else statement to set the variable `xlabel` to one thing if `input$display_var` is equivalent to `"eruptions"`, and to something else if it's equivalent to `"waiting"`. Put this code at the very beginning of the code block for the `renderPlot` function (after the line `output$distPlot <- renderPlot({`).


```r
      # set x-axis label depending on the value of display_var
      if (input$display_var == "eruptions") {
        xlabel <- "Eruption Time (in minutes)"
      } else if (input$display_var == "waiting") {
        xlabel <- "Waiting Time to Next Eruption (in minutes)"
      }
```

::: {.warning}
The double-equal-signs `==` means "equivalent to and is how you check if two things are the same; if you only use one equal sign, you set the variable on the left to the value on the right.
:::

Then we have to edit the `ggplot` function to use the new label and to plot the correct column. The variable `input$display_var` gives you the user-input value of the widget called `display_var`.


```r
      # create plot
      ggplot(faithful, aes(.data[[input$display_var]])) +
        geom_histogram(bins = input$bins,
                       fill = "steelblue3",
                       colour = "grey30") +
        xlab(xlabel) +
        theme_minimal()
```

::: {.warning}
Notice that the function `aes(waiting)` from before has changed to `aes(.data[[input$display_var]])`. Because `input$display_var` is a <a class='glossary' target='_blank' title='A piece of text inside of quotes.' href='https://psyteachr.github.io/glossary/s#string'>string</a>, we have to select it from the `.data` placeholder (which refers to the `faithful` data table) using double brackets.
:::

Re-run your app and see if you can change the data and x-axis label with your new widget. If not, check your code against [the code](https://shiny.psy.gla.ac.uk/debruine/first_demo/){target="_blank"}.

<div class="figure" style="text-align: center">
<iframe src="https://shiny.psy.gla.ac.uk/debruine/first_demo/?showcase=0" width="100%" height="800px"></iframe>
<p class="caption">(\#fig:first-demo-app)First Demo App</p>
</div>

## Overview of the UI/server structure

Now that we've made and modified our first working app, it's time to learn a bit about how a shiny app is structured.

A shiny app is made of two main parts, a <a class='glossary' target='_blank' title='The User Interface. This usually refers to a Shiny App as the user will see it.' href='https://psyteachr.github.io/glossary/u#ui'>UI</a>, which defines what the user interface looks like, and a <a class='glossary' target='_blank' title='This is the part of a Shiny app that works with logic.' href='https://psyteachr.github.io/glossary/s#server'>server</a> function, which defines how the interface behaves. The function `shinyApp()` puts the two together to run the application in a web browser.


```r
# Load libraries ----
library(shiny)

# Define UI ----
ui <- fluidPage()

# Define server logic ----
server <- function(input, output) {
}

# Run the application ----
shinyApp(ui = ui, server = server)
```

::: {.try}
Create a new app called "basic_demo" and replace all the text in app.R with the code above. You should be able to run the app and see just a blank page.
:::

### UI

The UI is created by one of the ui-building "\*Page" functions from the shiny or shinydashboard package, such as `fluidPage()`, `fixedPage()`, `fillPage()` or `dashboardPage()`. The ui-building functions set up the parts of the webpage, which are created by more shiny functions that you list inside of the page function, separated by commas.

#### Tags

For example, the code below displays:

1.  a title panel with the text "Basic Demo"
2.  a level-two header with the text "My favourite things"
3.  an unordered list (`tags$ul`) containing several list items (`tags$li`)
4.  a paragraph with the text "This is a very basic demo."
5.  an image of the shinyintro logo with a width and height of 100 pixels


```r
ui <- fluidPage(
   titlePanel("Basic Demo"),
   h2("My favourite things"),
   tags$ul(
      tags$li("Coding"),
      tags$li("Cycling"),
      tags$li("Cooking")
   ),
   p("This is a very basic demo."),
  tags$img(src = "https://debruine.github.io/shinyintro/images/shinyintro.png", 
           width = "100px", height = "100px")
)
```

Many of the functions used to create parts of the website are the same as <a class='glossary' target='_blank' title='A way to mark the start and end of HTML elements.' href='https://psyteachr.github.io/glossary/t#tag'>HTML tags</a>, which are ways to mark the beginning and end of different types of text. Most HTML tags are available in shiny by using one of the `tags()` sub-functions, but some of the more common tags, like `p()` or h1()`-`h6()`also have a version where you can omit the`tags\$\` part. You can see a list of all of the tags available in Shiny at the [tag glossary](https://shiny.rstudio.com/articles/tag-glossary.html){target="_blank"}

::: {.try}
Add the code above to your basic_demo" app and replace my favourite things with yours. Make the list an ordered list (instead of unordered) and change the image size.
:::

#### Page Layout

You usually want your apps to have a more complex layout than just each element stacked below the previous one. The code below wraps the elements after the title panel inside a `flowLayout()`.


```r
ui <- fluidPage(
  titlePanel("Basic Demo"),
  flowLayout(
    h2("My favourite things"),
    tags$ul(
      tags$li("Coding"),
      tags$li("Cycling"),
      tags$li("Cooking")
    ),
    p("This is a very basic demo."),
    tags$img(
      src = "https://debruine.github.io/shinyintro/images/shinyintro.png",
      width = "100px", height = "100px"
    )
  )
)
```

::: {.try}
Replace the ui code in your basic_demo" app with the code above and run it in a web browser. What happens when you change the width of the web browser? Change `flowLayout` to `verticalLayout` or `splitLayout` and see what changes.
:::

You can use a `sidebarLayout()` to arrange your elements into a `sidebarPanel()` and a `mainPanel()`. If the browser width is too narrow, the sidebar will display on top of the main panel.


```r
ui <- fluidPage(
   titlePanel("Basic Demo"),
   sidebarLayout(
      sidebarPanel(
         h2("My favourite things"),
         tags$ul(
            tags$li("Coding"),
            tags$li("Cycling"),
            tags$li("Cooking")
         )
      ),
      mainPanel(
         p("This is a very basic demo."),
         tags$img(
            src = "https://debruine.github.io/shinyintro/images/shinyintro.png",
            width = "100px", height = "100px"
         )
      )
   )
)
```


## Inputs, outputs, and action buttons

So far, we've just put <a class='glossary' target='_blank' title='Something that does not change in response to user actions' href='https://psyteachr.github.io/glossary/s#static'>static</a> elements into our UI. What makes Shiny apps work is <a class='glossary' target='_blank' title='Something that can change in response to user actions' href='https://psyteachr.github.io/glossary/d#dynamic'>dynamic</a> elements like inputs, outputs, and action buttons. 

### Inputs {#inputs-intro}

Inputs are ways for the users of your app to communicate with the app. They are things like drop-down menus or checkboxes. We'll go into the different types of inputs in the [Inputs chapter](#inputs).  Below we'll turn the list of favourite things into a checkbox list.


```r
checkboxGroupInput(inputId = "fav_things", 
                   label = "What are your favourite things?",
                   choices = c("Coding", "Cycling", "Cooking")
)
```

Most inputs are structured like this, with an inputId, which needs to be a unique string not used as the ID for any other input or output in your app, a label that contains the question, and a list of choices or other parameters that determine what type of values the input will record.

### Outputs {#outputs-intro}

Outputs are placeholders for things that `server()` will create. There are different output functions for different types of outputs, like text, plots, and tables. We'll go into the different types of outputs in detail in the [Outputs chapter](#outputs). Below, we'll make a placeholder for some text that we'll display after counting the number of favourite things.


```r
textOutput(outputId = "n_fav_things")
```

Most outputs are structured like this, with just a unique outputId.


### Action buttons

Action buttons are a special type of input that register button clicks. Below we'll make an action button that users can click once they've selected all of their favourite things.


```r
actionButton(inputId = "count_fav_things",
             label = "Count",
             icon = icon("calculator")
)
```

Action buttons require a unique inputId and a label for the button text. You can also add an icon. Choose a free icon from [fontawesome](https://fontawesome.com/icons?d=gallery&m=free){target="_blank"}.

Put the input, output, and action button into the ui and run it. You can see that the input checkboxes are selectable and the button is clickable, but nothing is displayed in the text output. We need some code in `server()` to handle that.


```r
ui <- fluidPage(
   titlePanel("Basic Demo"),
   sidebarLayout(
      sidebarPanel(
         checkboxGroupInput(inputId = "fav_things", 
                   label = "What are your favourite things?",
                   choices = c("Coding", "Cycling", "Cooking")
         ),
         actionButton(inputId = "count_fav_things",
             label = "Count",
             icon = icon("calculator")
         )
      ),
      mainPanel(
         textOutput(outputId = "n_fav_things")
      )
   )
)
```

## Reactive functions {#first-reactive}

Reactive functions are functions that run when their inputs change. Inside the server function, the <a class='glossary' target='_blank' title='A word that identifies and stores the value of some data for later use.' href='https://psyteachr.github.io/glossary/o#object'>object</a> `input` is a named <a class='glossary' target='_blank' title='A container data type that allows items with different data types to be grouped together.' href='https://psyteachr.github.io/glossary/l#list'>list</a> of the values of all of the inputs. For example, if you want to know which items in the select input named "fav_things" were selected, you would use `input$fav_things`.

Here, we just want to count how many items are checked. We want to do this whenever the button "count_fav_things" is clicked, so we can use the reactive function `observeEvent()` to do this. Every time the value of `input$count_fav_things` changes (which happens when it is clicked), it will run the code inside of the curly brackets `{}`. The code will only run when `input$count_fav_things` changes, not when any inputs inside the function change.


```r
server <- function(input, output) {
   # count favourite things
   observeEvent(input$count_fav_things, {
      n <- length(input$fav_things)
      count_text <- sprintf("You have %d favourite things", n)
    })
}
```

Now we want to display this text in the output "n_fav_things". We need to use a render function that is paired with our output function. Since "n_fav_things" was made with `textOutput()`, we fill it with `renderText()`. 


```r
server <- function(input, output) {
   # count favourite things
   observeEvent(input$count_fav_things, {
      n <- length(input$fav_things)
      count_text <- sprintf("You have %d favourite things", n)
      output$n_fav_things <- renderText(count_text)
   })
}
```

As always in coding, there are many ways to accomplish the same thing. These methods have different pros and cons that we'll learn more about in the [Reactive chapter](#reactives). Here is another pattern that does that same as above.

This pattern uses `reactive()` to update the value of a new function called `count_text()` whenever any inputs inside the reactive function change. We use `isolate()` to prevent `count_text()` from changing when users click the checkboxes. 

Whenever the returned value of `count_text()` changes, this triggers an update of the "n_fav_things" output.


```r
server <- function(input, output) {
   # update count_text on fav_things
   count_text <- reactive({
      input$count_fav_things # just here to trigger the reactive
      fav_things <- isolate(input$fav_things) # don't trigger on checks
      n <- length(fav_things)
      sprintf("You have %d favourite things", n)
   })
   
   # display count_text when it updates
   output$n_fav_things <- renderText(count_text())
}
```

::: {.try}
Compare the app behaviour with the first pattern versus the second. How are they different? What happens if you remove `isolate()` from around `input$fav_things`?
:::

## Further Resources {#resources-first-app}

* [Application layout guide](https://shiny.rstudio.com/articles/layout-guide.html){target="_blank"}


## Exercises {#exercises-first-app}

### Addition App - UI

Create the UI for following [addition app](https://shiny.psy.gla.ac.uk/debruine/add_demo/){target="_blank"}. Use `numericInput()` to create the inputs.


<div class="figure" style="text-align: center">
<iframe src="https://shiny.psy.gla.ac.uk/debruine/add_demo/?showcase=0" width="100%" height="400px"></iframe>
<p class="caption">(\#fig:add-demo-app)Add Demo App</p>
</div>


<div class='webex-solution'><button>Solution</button>



```r
ui <- fluidPage(
  titlePanel("Addition Demo"),
  sidebarLayout(
    sidebarPanel(
      numericInput("n1", "First number", 0),
      numericInput("n2", "Second number", 0),
      actionButton("add", "Add Numbers")
    ),
    mainPanel(
      textOutput(outputId = "n1_plus_n2")
    )
  )
)
```


</div>


### observeEvent

Use `observeEvent()` to write a server function that displays "n1 + n2 = sum" when you click the action button.


<div class='webex-solution'><button>Solution</button>



```r
server <- function(input, output) {
  # add numbers
  observeEvent(input$add, {
    sum <- input$n1 + input$n2
    add_text <- sprintf("%d + %d = %d", input$n1, input$n2, sum)
    output$n1_plus_n2 <- renderText(add_text)
  })
}
```


</div>


### reactive

Use `reactive()` to accomplish the same behaviour.


<div class='webex-solution'><button>Solution</button>



```r
server <- function(input, output) {
  add_text <- reactive({
    input$add # triggers reactive
    n1 <- isolate(input$n1)
    n2 <- isolate(input$n2)
    sprintf("%d + %d = %d", n1, n2, n1 + n2)
  })
  
  output$n1_plus_n2 <- renderText(add_text())
}
```


</div>

