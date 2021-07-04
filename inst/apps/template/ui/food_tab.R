### food_tab ----

# set up tab in sheet if not there
if (gs4_has_token() &&
    !"food" %in% gs4_get(SHEET_ID)$sheets$name) {
  sheet_add(SHEET_ID, "food")
}

# radio_table setup
food_q <- list(
  apple = "Apples 🍎",
  banana = "Bananas 🍌",
  carrot = "Carrots 🥕",
  donut = "Donuts 🍩",
  eggplant = "Eggplants 🍆"
)

food_opts <- c(
  "Hate it",
  "Dislike it", 
  "Meh",
  "Like it",
  "Love it"
)

food_tab <- tabItem(
  tabName = "food_tab",
  box(id = "food_box", title = "Food Questionnaire", width = 12, collapsible = T,
      p("How much do you like each food?"),
      radioTableInput("food_table", food_q, food_opts, random = FALSE),
      actionButton("food_submit", "Submit")
  ),
  tabsetPanel(id = "food_plots",
              tabPanel("Individual Data", plotOutput("food_plot")),
              tabPanel("Summary Data", plotOutput("food_summary"))
  )
)