# Debugging and error handling {#debugging}

Bugs are a part of coding. A great coder isn't someone who writes bug-free code on the first try (this is an unachievable goal), but rather someone who knows how to efficiently catch bugs. This sections presents a few simple ways to debug your Shiny app. See the article [Debugging Shiny applications](https://shiny.rstudio.com/articles/debugging.html){target="_blank"} for further debugging strategies, including breakpoints and [reactlog](https://rstudio.github.io/reactlog/){target="_blank"}.

## RStudio Console Messages

Sending messages to the <a class='glossary' target='_blank' title='The pane in RStudio where you can type in commands and view output messages.' href='https://psyteachr.github.io/glossary/c#console'>console</a> is a simple way to debug your code.

I like to keep track of what functions are being called by starting every function inside the server function with a message. The template includes a custom message logging function that helps you use this with both development and deployed apps: `debug_msg()`. For example, the code below prints "questionnaire submitted" every time the action button `q_submit` is pressed. It prints to the RStudio console when you're developing and to the javascript console for deployed apps.


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

Shiny puts a lot of info you won't care about into the logs, so our `debug_msg()` function writes messages to the debug console. You can filter just those messages by choosing only "Debug" in FireFox or "Verbose" in Chrome.

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

## Glossary {#glossary-debugging}


|term                                                                                                  |definition                                                                   |
|:-----------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------|
|<a class='glossary' target='_blank' href='https://psyteachr.github.io/glossary/c#console'>console</a> |The pane in RStudio where you can type in commands and view output messages. |
