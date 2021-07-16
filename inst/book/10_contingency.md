# Contingent Display {#contingency}

<div class="figure" style="text-align: center">
<iframe src="https://shiny.psy.gla.ac.uk/debruine/contingency_demo/?showcase=0" width="100%" height="800px"></iframe>
<p class="caption">(\#fig:contingency-demo-app)Contingency Demo App</p>
</div>

## Hide and Show

I frequently want to make some aspect of a shiny app contingent on the state of another aspect, such as only showing a text input of the value of a select input is "other". You can use the `hide()` and `show()` functions from shinyjs to accomplish this easily.

When you set up the UI, wrap any elements that should be hidden at the start in `hidden()`.


```r
# in the ui
box(title = "Questions",
    solidHeader = TRUE,
    selectInput("first_pet", "What was your first pet?", 
                c("", "dog", "cat", "ferret", "other")),
    hidden(textInput("first_pet_other", NULL, 
                     placeholder = "Specify the other pet"))
)
```

Then set up the hide and show logic in `server()`. 


```r
# in the server
observeEvent(input$first_pet, {
    if (input$first_pet == "other") {
        show("first_pet_other")
    } else {
        hide("first_pet_other")
    }
})
```

### Groups

Sometimes you need to hide and show a group of elements, depending on something else. You can wrap the grouped elements in a div tag with an id and hide and show that id.

For example, it doesn't make sense to show the questions above to someone who has never had a pet. Add a `selectInput()` before the previous two questions, and then wrap those questions in `tags$div()` with an id of "first_pet_grp"


```r
# replace in ui
box(
  title = "Questions",
  solidHeader = TRUE,
  selectInput("had_pet", "Have you ever had a pet?", c("", "Yes", "No")),
  hidden(tags$div(
    id = "first_pet_grp",
    selectInput("first_pet", "What was your first pet?",
                c("", "dog", "cat", "ferret", "other")),
    textInput("first_pet_other", NULL,
              placeholder = "Specify the other pet")
  ))
)
```

Then add the following code to the server function to hide or show `first_pet_grp` depending on the value of `had_pet`. The server code above will take care of whether or not `first_pet_other` is visible.


```r
# add to server
observeEvent(input$had_pet, {
  if (input$had_pet == "Yes") {
    show("first_pet_grp")
  } else {
    hide("first_pet_grp")
  }
})
```

::: {.try}
Try to figure out what could go wrong if you didn't wrap "first_pet" and "first_pet_other" in a group, and instead just hid or showed "first_pet" and "first_pet_other" depending on the value of `has_pet`?
:::

### Toggle

Sometimes you need to change the visibility of an element when something happens, rather than specifically hide or show it. You can use `toggle()` to hide an element if it's visible and show it if it's hidden.

Add an `actionButton()` to the sidebar menu (not inside the box) and give the box an id of "pet_box". Any element that you might want to refer to in the code needs an id.


```r
# add to ui
actionButton("toggle_pet_box", "Toggle Pet Questions")
```

Now, whenever you click the "toggle_pet_box" button, the contents of "pet_box" will toggle their visibility.


```r
# add to server
observeEvent(input$toggle_pet_box, {
  toggle("pet_box")
})
```

::: {.try}
What would go wrong if you put the button inside the box?
:::

## Changing Styles

You can use `addClass()`, `removeClass()`, and `toggleClass()` to change element classes. You usually want to do this with classes you've defined yourself. 

Add the following style to the `www/custom.css` file.


```r
.notice-me {
  color: red;
  text-decoration: underline;
  font-weight: 800;
}
```

And add this box to the ui:


```r
box(title = "Notice", solidHeader = TRUE,
    p(id = "notice_text", "Please pay attention to this text."),
    actionButton("add_notice", "Notice Me"),
    actionButton("remove_notice", "Ignore Me"),
    actionButton("toggle_notice", "Toggle Me")
)
```

This code adds the class `notice-me` to the paragraph element "notice_text" whenever the "add_notive" button is pressed.


```r
observeEvent(input$add_notice, {
  addClass("notice_text", "notice-me")
})
```

::: {.try}
Guess how you would use `removeClass()`, and `toggleClass()` with the buttons set up above.
:::


### Changing non-shiny elements

Unfortunately, not all elements on the web page have an ID that can be altered by `addClass()` or `removeClass()`. For example, the skin of a shinydashboard app is determined by the css class of the body element. However, we can use `runjs()` to run any arbitrary [JavaScript](#JavaScript) code. 

Add the following action button into the sidebar menu.


```r
actionButton("random_skin", "Random Skin")
```

The <a class='glossary' target='_blank' title='A library that makes it easier to write JavaScript.' href='https://psyteachr.github.io/glossary/j#jquery'>jQuery</a> code below changes the skin of your app on a button press by removing all possible skin-color classes and adding a random one.


```r
observeEvent(input$random_skin, {
  skins <- c("red", "yellow", "green", "blue", "purple", "black")
  skin_color <- sample(skins, 1)
  
  js <- sprintf("$('body').removeClass('%s').addClass('skin-%s');",
                paste(paste0("skin-", skins), collapse = " "),
                skin_color)
  
  shinyjs::runjs(js)
})
```

::: {.info}
Changing the skin color with a button press isn't something you'll easily find documented in online materials. I figured it out through looking at how the underlying html changed when I changed the skin color in the app code. Hacks like this require lots of trial and error, but get easier the more you understand about html, css and JavaScript.
:::

## Changing input options

The relevant options in a `selectInput()` or `radioButton()` may change depending on the values of other inputs. Sometimes you can accommodate this by creating multiple versions of a input and hiding or showing. Other times you may wish to update the input directly.

Add the following box to the ui.


```r
box(title = "Data", solidHeader = TRUE, width = 12,
  selectInput("dataset", "Choose a dataset", c("mtcars", "sleep")),
  checkboxGroupInput("columns", "Select the columns to show", inline = TRUE),
  tableOutput("data_table")
)
```

First, set up the code to display the correct data in the table.


```r
mydata <- reactive({
  if (input$dataset == "mtcars") { mtcars } else { sleep }
})

output$data_table <- renderTable(mydata())
```


Now we need to set the options for "columns" depending on which "dataset" is selected.


```r
observe({
  col_names <- names(data())
  debug_msg(col_names)
  updateCheckboxGroupInput(inputId = "columns",
                           choices = col_names,
                           selected = col_names)
})
```

Finally, we can add some code to select only the checked columns to display.


```r
observe({
  full_data <- if (input$dataset == "mtcars") { mtcars } else { sleep }
  col_names <- names(full_data)
  updateCheckboxGroupInput(
    inputId = "columns",
    choices = col_names,
    selected = col_names,
    inline = TRUE
  )
})
```

::: {.try}
Why do we have to get the dataset again instead of using the data from `mydata()`?
:::

Finally, alter the reactive function to only show the selected columns.


```r
mydata <- reactive({
  d <- if (input$dataset == "mtcars") { mtcars } else { sleep }
  d[input$columns]
})
```

::: {.try}
What happens when you unselect all the columns? How can you fix this?
:::


## Glossary {#glossary-contingency}



|term                                                                                                |definition                                          |
|:---------------------------------------------------------------------------------------------------|:---------------------------------------------------|
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/j#jquery'>jquery</a> |A library that makes it easier to write JavaScript. |



## Exercises {#exercises-contingency}



