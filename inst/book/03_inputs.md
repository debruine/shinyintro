# Inputs {#inputs}

## Input functions

Inputs are ways that users can communicate information to the Shiny app. Explore some different input types in the embedded app below before you read about how to set up each type. You can run this app locally with `shinyintro::app("input_demo")` or view it in a separate tab with the [showcase interface](https://shiny.psy.gla.ac.uk/debruine/input_demo/){target="_blank"}.

<div class="figure" style="text-align: center">
<iframe src="https://shiny.psy.gla.ac.uk/debruine/input_demo/?showcase=0" width="100%" height="800px"></iframe>
<p class="caption">(\#fig:input-demo-app)Input Demo App</p>
</div>

### textInput

`textInput()` creates a one-line box for short text input.


```r
demo_text <- 
  textInput("demo_text", 
            label = "Name", 
            value = "", 
            width = "100%",
            placeholder = "Your Name")
```

### textAreaInput

`textAreaInput()` creates a multi-line box for longer text input.


```r
demo_textarea <- 
  textAreaInput("demo_textarea", 
                label = "Biography", 
                value = "",
                width = "100%",
                rows = 5, 
                placeholder = "Tell us something interesting about you.")
```

### selectInput

`selectInput()` creates a drop-down menu. Set the first choice to `""` to default to `NA`. If your choices are a named <a class='glossary' target='_blank' title='A container data type that allows items with different data types to be grouped together.' href='https://psyteachr.github.io/glossary/l#list'>list</a> or <a class='glossary' target='_blank' title='A type of data structure that is basically a list of things like T/F values, numbers, or strings.' href='https://psyteachr.github.io/glossary/v#vector'>vector</a>, the names are what is shown and the values are what is recorded. If the choices aren't named, the displayed and recorded values are the same.


```r
demo_select <- 
  selectInput("demo_select", 
              label = "Do you like Shiny?", 
              choices = list("", 
                             "Yes, I do" = "y", 
                             "No, I don't" = "n"),
              selected = NULL,
              width = "100%")
```

You can also make a select where users can choose multiple options.


```r
genders <- list( # no blank needed
  "Non-binary" = "nb",
  "Male" = "m",
  "Female" = "f",
  "Agender" = "a",
  "Gender Fluid" = "gf"
)

demo_select_multi <- 
  selectInput("demo_select2", 
              label = "Gender (select all that apply)", 
              choices = genders,
              selected = NULL,
              multiple = TRUE, 
              selectize = FALSE,
              size = 5)
```

### checkboxGroupInput

However, this interface almost always looks better with a checkbox group. 


```r
demo_cbgi <-
  checkboxGroupInput("demo_cbgi",
                     label = "Gender (select all that apply)",
                     choices = genders)
```

### checkboxInput

You can also make a single checkbox. The value is `TRUE` when checked and `FALSE` when not.


```r
demo_cb <- checkboxInput("demo_cb",
                         label = "I love R",
                         value = TRUE)
```

Sliders allow you to choose numbers between a minimum and maximum.


```r
demo_slider <- sliderInput("demo_slider",
                           label = "Age",
                           min = 0,
                           max = 100,
                           value = 0,
                           step = 1,
                           width = "100%")
```

### radioButtons


```r
demo_radio <- radioButtons("demo_radio",
                           label = "Choose one",
                           choices = c("Cats", "Dogs"))
```


## Setting inputs programatically

Sometimes you need to change the value of an input with code, such as when resetting a questionnaire or in response to an answer on another item. The following code resets all of the inputs above.


```r
updateTextInput(session, "demo_text", value = "")
updateTextAreaInput(session, "demo_textarea", value = "")
updateSelectInput(session, "demo_select", selected = "")
updateCheckboxGroupInput(session, "demo_cbgi", selected = character(0))
updateCheckboxInput(session, "demo_cb", value = TRUE)
updateSliderInput(session, "demo_slider", value = 0)
```

::: {.warning}
Note that select inputs and checkbox groups use the argument `selected` and not `value`. If you want to set all the values in a checkbox group to unchecked, set `selected = character(0)`.
:::

