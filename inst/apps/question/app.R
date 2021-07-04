# libraries ----
suppressPackageStartupMessages({
    library(shiny)
    library(shinyjs)
    library(shinydashboard)
    library(ggplot2)
    library(dplyr)
    library(tidyr)
})

# setup ----
theme_set(theme_minimal(base_size = 16))

if (!dir.exists("data/hand")) dir.create("data/hand", recursive = TRUE)
if (!dir.exists("data/tipi")) dir.create("data/tipi", recursive = TRUE)

# functions ----

source("R/func.R") 
source("R/radio_table.R") 

# user interface ----

## tabs ----
source("ui/tipi_tab2.R")
source("ui/bfi2_tab.R")
source("ui/plot_tab.R")
source("ui/bpaq_tab.R")
source("ui/hand_tab.R")

# if the header and/or sidebar get too complex, 
# put them in external files and uncomment below 
# source("ui/header.R") # defines the `header`
# source("ui/sidebar.R") # defines the `sidebar`

skin <- sample(c("red", "yellow", "green", "blue", "purple", "black"), 1)

## UI ----
ui <- dashboardPage(
    skin = skin,
    # header, # if sourced above
    dashboardHeader(title = "Questions"),
    # sidebar, # if sourced above
    dashboardSidebar(
        # https://fontawesome.com/icons?d=gallery&m=free
        sidebarMenu(
            id = "tabs",
            menuItem("Handedness", tabName = "hand_tab",
                     icon = icon("hand-spock")),
            menuItem("TIPI", tabName = "tipi_tab",
                     icon = icon("clipboard")),
            menuItem("BFI2", tabName = "bfi2_tab",
                     icon = icon("smile")),
            menuItem("BPAQ", tabName = "bpaq_tab",
                     icon = icon("hand-rock"))
            #menuItem("Plots", tabName = "plot_tab",
            #         icon = icon("chart-line"))
        )
    ),
    dashboardBody(
        shinyjs::useShinyjs(),
        tags$head(
            # links to files in www/
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"), 
            tags$link(rel = "stylesheet", type = "text/css", href = "radio-table.css"),
            tags$script(src = "custom.js"),
            tags$script(src = "radio-table.js")
        ),
        tabItems(
            tipi_tab,
            bfi2_tab,
            bpaq_tab,
            hand_tab
            #plot_tab
        )
    )
)


# server ----
server <- function(input, output, session) {
    debug_msg("initialize reactive vars")
    v <- reactiveValues()
    v$hand_files <- list.files("data/hand", pattern = ".\\json$", full.names = TRUE)

    # get questionnaires as data tables on submit ----
    
    ## hand_submit ----
    observeEvent(input$hand_submit, { debug_msg("hand_submit")
        updateTabsetPanel(session, "hand_tabset", selected = "Feedback")
        
        vars <- get_radio_table_inputs("hand_table", input) 
        
        labels <- c("Always Left",
                    "Usually Left",
                    "No Preference",
                    "Usually Right",
                    "Always Right")
        
        v$hand <- as.data.frame(vars) %>%
            pivot_longer(starts_with("hand_"),
                         names_to = "q",
                         values_to = "category") %>%
            filter(category != "") %>%
            mutate(category = factor(category, 1:5, labels, )) %>%
            count(category, .drop = FALSE)
        
        # save data
        data <- as.data.frame(vars)
        data$session_id <- session$token
        data$dt <- Sys.time()
        filename <- sprintf("data/hand/%s_%s.json", 
                            data$session_id, data$dt)
        jsonlite::write_json(data, filename)
        v$hand_files <- list.files("data/hand", pattern = ".\\json$", full.names = TRUE)
    })
    
    ## tipi_submit ----
    observeEvent(input$tipi_submit, { debug_msg("tipi_submit")
        updateTabsetPanel(session, "tipi_tabset", selected = "Feedback")
        
        v$tipi <- get_radio_table_inputs("tipi_table", input) %>%
            as.data.frame() %>%
            pivot_longer(everything(),
                         names_to = c("category", "n"),
                         names_sep = "_",
                         values_to = "score") %>%
            group_by(category) %>%
            summarise(score = mean(score, na.rm = TRUE), .groups = "drop") %>%
            mutate(category = factor(category, c("E", "A", "C", "S", "O"), 
                                     c("Extraversion", 
                                       "Agreeableness", 
                                       "Conscientiousness", 
                                       "Emotional Stability", 
                                       "Openness to Experiences")))
    })
    
    ## bfi2_submit ----
    observeEvent(input$bfi2_submit, { debug_msg("bfi2_submit")
        updateTabsetPanel(session, "bfi2_tabset", selected = "Feedback")
        
        v$bfi2 <- get_radio_table_inputs("bfi2_table", input) %>%
            as.data.frame() %>%
            pivot_longer(everything(),
                         names_to = c("bfi", "category", "n"),
                         names_sep = "_",
                         values_to = "score") %>%
            group_by(category) %>%
            summarise(score = mean(score, na.rm = TRUE), .groups = "drop") %>%
            mutate(category = factor(category, c("E", "A", "C", "N", "O"), 
                                     c("Extraversion", 
                                       "Agreeableness", 
                                       "Conscientiousness", 
                                       "Negative Emotionality", 
                                       "Openness to Experiences")))
    })
    
    ## bpaq_submit ----
    observeEvent(input$bpaq_submit, { debug_msg("bpaq_submit")
        updateTabsetPanel(session, "bpaq_tabset", selected = "Feedback")
        
        v$bpaq <- get_radio_table_inputs("bpaq_table", input) %>%
            as.data.frame() %>%
            pivot_longer(everything(),
                         names_to = c("bpaq", "category", "n"),
                         names_sep = "_",
                         values_to = "score") %>%
            mutate(category = factor(category, c("P", "V", "A", "H"), 
                                     c("Physical", 
                                       "Verbal", 
                                       "Angry", 
                                       "Hostile"))) %>%
            group_by(category) %>%
            summarise(score = mean(score, na.rm = TRUE), .groups = "drop")
    })
    
    ## hand_data ----
    hand_data <- reactive({
        # read all data when v$hand_files updates
        labels <- c("Always Left",
                    "Usually Left",
                    "No Preference",
                    "Usually Right",
                    "Always Right")
        
        lapply(v$hand_files, jsonlite::read_json) %>%
            do.call(dplyr::bind_rows, .) %>%
            group_by(session_id) %>%
            filter(row_number() == 1) %>%
            ungroup() %>%
            pivot_longer(starts_with("hand_"),
                         names_to = "q",
                         values_to = "category") %>%
            filter(category != "") %>%
            mutate(category = factor(category, 1:5, labels)) %>%
            count(session_id, category, .drop = FALSE)
    })
    
    
    
    # plots ----
    
    ## hand_plot ----
    output$hand_plot <- renderPlot({ debug_msg("hand_plot")
        g <- ggplot(hand_data(), aes(x = category, y = n, color = category)) +
            geom_violin(fill = "white") +
            geom_line(aes(group = session_id), color = "grey") +
            scale_fill_viridis_d(drop=FALSE) +
            scale_x_discrete(name = "", drop = FALSE) +
            scale_y_continuous(name = "", breaks = 0:15, limits = c(0, 15)) +
            theme(legend.position = "none")
        
        if (!is.null(v$hand)) {
            g <- g + geom_point(data = v$hand, size = 10)
        }
        g
    })
    
    ## tipi_plot ----
    output$tipi_plot <- renderPlot({ debug_msg("tipi_plot")
        if (is.null(v$tipi)) return()
        ggplot(v$tipi, aes(x = category, y = score, fill = category)) +
            geom_col(show.legend = FALSE) +
            scale_fill_viridis_d() +
            scale_y_continuous(limits = c(0, 7), breaks = 1:7)
    })
    
    ## bpaq_plot ----
    output$bpaq_plot <- renderPlot({ debug_msg("bpaq_plot")
        if (is.null(v$bpaq)) return()
        ggplot(v$bpaq, aes(x = category, y = score, fill = category)) +
            geom_col(show.legend = FALSE) +
            scale_fill_viridis_d() +
            scale_y_continuous(limits = c(0, 5), breaks = 1:5) +
            scale_x_discrete(name = "Aggression Category")
    })
    
    ## bfi2_plot ----
    output$bfi2_plot <- renderPlot({ debug_msg("bfi2_plot")
        if (is.null(v$bfi2)) return()
        ggplot(v$bfi2, aes(x = category, y = score, fill = category)) +
            geom_col(show.legend = FALSE) +
            scale_fill_viridis_d() +
            scale_y_continuous(limits = c(0, 5), breaks = 1:5)
    })
} 

shinyApp(ui, server)