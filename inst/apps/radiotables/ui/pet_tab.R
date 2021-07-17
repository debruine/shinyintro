### pet_tab ----

# set up tab in sheet if not there
if (USING_GS4 &&
    !"pet" %in% gs4_get(SHEET_ID)$sheets$name) {
  sheet_add(SHEET_ID, "pet")
} else if (!file.exists("data/pet.csv")) {
  write_csv(data.frame(), "data/pet.csv")
}

# radio_table setup
pet_tab <- tabItem(
  tabName = "pet_tab",
  box(
    id = "pet_box",
    width = 12,
    collapsible = TRUE,
    collapsed = FALSE,
    solidHeader = TRUE,
    title = "Pet Questionnaire",
    p("How much do you like each pet?"),
    radioTableInput("pet_table", pet_q, pet_opts, random = FALSE),
    actionButton("pet_submit", "Submit")
  ),
  tabsetPanel(
    id = "pet_plots",
    tabPanel("Individual Data", plotOutput("pet_plot")),
    tabPanel("Summary Data", plotOutput("pet_summary"))
  )
)