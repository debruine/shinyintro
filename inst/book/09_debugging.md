# Debugging and error handling {#debugging}

Bugs are a part of coding. A great coder isn't someone who writes bug-free code on the first try (this is an unachievable goal), but rather someone who knows how to efficiently catch bugs. This sections presents a few simple ways to debug your Shiny app. See the article [Debugging Shiny applications](https://shiny.rstudio.com/articles/debugging.html){target="_blank"} for further debugging strategies, including breakpoints and [reactlog](https://rstudio.github.io/reactlog/){target="_blank"}.

## RStudio Console Messages

Sending messages to the <a class='glossary' target='_blank' title='The pane in RStudio where you can type in commands and view output messages.' href='https://psyteachr.github.io/glossary/c#console'>console</a> is a simple way to debug your code.

I like to keep track of what functions are being called by starting every function inside the server function with a message. The template includes a custom message logging function that helps you use this with both development and deployed apps: `debug_msg()`. 


```r
# display debugging messages in R if local, 
# or in the console log if remote
debug_msg <- function(...) {
  is_local <- Sys.getenv('SHINY_PORT') == ""
  txt <- toString(list(...))
  if (is_local) {
    message(txt)
  } else {
    shinyjs::runjs(sprintf("console.debug(\"%s\")", txt))
  }
}
```



For example, the code below prints "questionnaire submitted" every time the action button `q_submit` is pressed. It prints to the RStudio console when you're developing and to the javascript console for deployed apps.


```r
observeEvent(input$q_submit, {
  debug_msg("questionnaire submitted")
  # rest of code ...
})
```

## JavaScript Console

I use [FireFox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/){target="_blank"} when I'm developing web apps, but Chrome also has developer tools. In FireFox, go to **`Tools > Browser Tools > Web Developer Tools`** (opt-cmd-I). In Chrome, go to **`View > Developer > Developer Tools`** (opt-cmd-I). You can dock the tools to the bottom, right , or left of the window, or as a separate window. 

<div class="figure" style="text-align: center">
<img src="images/js_console_firefox.png" alt="Javascript consoles in FireFox Developer Edition and Chrome." width="30%" /><img src="images/js_console_chrome.png" alt="Javascript consoles in FireFox Developer Edition and Chrome." width="30%" />
<p class="caption">(\#fig:js-console)Javascript consoles in FireFox Developer Edition and Chrome.</p>
</div>

Shiny puts a lot of info you won't care about into the logs, so `debug_msg()` writes messages to the debug console. You can filter just those messages by choosing only "Debug" in FireFox or "Verbose" in Chrome.

## Showcase Mode

You can view an app in showcase mode by setting "DisplayMode" to "Showcase" (instead of "Normal") in the DESCRIPTION file in the app directory. When you're in this mode, you can see your app code, css files, and javascript files. The functions in your server function will highlight in yellow each time they are run. However, this isn't much help if many of your functions are in external files or you are using modules. Also, if your script is very long, you won't be able to see the highlighting unless you've scrolled to the right section, so I find it more straightforward to use the message method described above.

```
Title: Questionnaire Template
Author: Lisa DeBruine
License: CC-BY-4.0
DisplayMode: Showcase
Type: Shiny
```

<div class="figure" style="text-align: center">
<img src="images/showcase_mode.png" alt="Showcase mode." width="100%" />
<p class="caption">(\#fig:showcase-mode)Showcase mode.</p>
</div>

## tryCatch

You've probably experienced the greyed out screen of a crashed app more than enough now. In development, the next step is to look at the console to see if you have a warning or error message. If you're lucky, you can figure out where in the code this is happening (this is easier if you start all your functions with a debug message). 

However, sometimes there are errors that are difficult to prevent. For example, you can try to restrict inputs so the users only enter numeric values using `numericInput()`, but some browsers will let you enter text values anyways. To avoid crashing the whole app, you can wrap potentially error-triggering code in `tryCatch()`. 

For example, the code below will cause an error because you can't add a number and a letter.


```r
input <- list(n1 = 10, n2 = "A")

sum <- input$n1 + input$n2
```

```
## Error in input$n1 + input$n2: non-numeric argument to binary operator
```

The following code tries to run the code inside the curly brackets (`{}`), but if it creates an error, the error function will run. The object `e` is the error object, and you can print the message from it using `debug_msg()` (this won't crash the app). 


```r
sum <- tryCatch({
  input$n1 + input$n2
}, error = function(e) {
  debug_msg(e$message)
  return(0)
})
```

The return value from the error message is the value assigned to `sum` if there is an error. Sometimes it won't make sense to have a default value, or the code you're checking doesn't have a return value. In that case, you can just put all the code inside the brackets and not return anything from the error function.


```r
tryCatch({
  sum <- input$n1 + input$n2
  output$sum <- renderText(sum)
}, error = function(e) {
  debug_msg(e$message)
})
```

## Input Checking

The user above might be frustrated if they've made a mistake that causes an error and don't know what it was. You can help prevent errors and make the experience of using your app nicer by doing input checking and sending your users useful messages.


```r
observeEvent(input$submit, {
  # check inputs
  input_error <- dplyr::case_when(
    !is.numeric(input$n1) ~ "N1 needs to be a number",
    !is.numeric(input$n2) ~ "N2 needs to be a number",
    TRUE ~ ""
  )
  if (input_error != "") {
    shinyjs::alert(input_error)
    return() # exit the function here
  }
  
  # no input errors
  sum <- input$n1 + input$n2
  output$sum <- renderText(sum)
})
```



## Glossary {#glossary-debugging}



|term                                                                                                  |definition                                                                   |
|:-----------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------|
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/c#console'>console</a> |The pane in RStudio where you can type in commands and view output messages. |


