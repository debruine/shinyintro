### pet_tab ----

# set up tab in sheet if not there
if (gs4_has_token() &&
    !"pet" %in% gs4_get(SHEET_ID)$sheets$name) {
  sheet_add(SHEET_ID, "pet")
}

# radio_table setup
pet_q <- list(
  dogs = "Dogs 🐕",
  cats = "Cats 🐈",
  birds = "Birds 🦜",
  fish = "Fish 🐠",
  mice = "Mice 🐁",
  hedgehogs = "Hedgehogs 🦔",
  snakes = "Snakes 🐍"
)

pet_opts <- c(
  "😨" = 1,
  "☹️" = 2,
  "🙁" = 3,
  "😕" = 4,
  "😐" = 5,
  "🙂" = 6,
  "😀" = 7,
  "😃" = 8,
  "😍" = 9
)

pet_tab <- tabItem(
  tabName = "pet_tab",
  box(id = "pet_box", title = "Pet Questionnaire", width = 12, collapsible = T,
      p("How much do you like each pet?"),
      radioTableInput("pet_table", pet_q, pet_opts, random = FALSE),
      actionButton("pet_submit", "Submit")
  ),
  tabsetPanel(id = "pet_plots",
              tabPanel("Individual Data", plotOutput("pet_plot")),
              tabPanel("Summary Data", plotOutput("pet_summary"))
  )
)