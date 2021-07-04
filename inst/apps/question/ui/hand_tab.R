# http://www.brainmapping.org/shared/Edinburgh.php

hand_q <- list(
  "Writing", 
  "Drawing",
  "Throwing",
  "Using Scissors",
  "Using a Toothbrush",
  "Using a Knife (without a fork)",
  "Using a Spoon",
  "Using a broom (upper hand)",
  "Striking a Match",
  "Opening a Box (holding the lid)",
  "Holding a Computer Mouse",
  "Using a Key to Unlock a Door",
  "Holding a Hammer",
  "Holding a Brush or Comb",
  "Holding a Cup while Drinking"
)

hand_opts <- c(
  "Always Left" = 1,
  "Usually Left" = 2,
  "No Preference" = 3,
  "Usually Right" = 4,
  "Always Right" = 5
)

# hand_tab ----
hand_tab <- tabItem(
  tabName = "hand_tab",
  h3("Edinburgh Handedness Inventory"),
  p("Which hand do you prefer to use when:"),
  tabsetPanel(id = "hand_tabset",
              tabPanel("Questionnaire", 
                       radioTableInput("hand_table", hand_q, hand_opts, q_width = "40%"),
                       actionButton("hand_submit", "Submit")),
              tabPanel("Feedback", 
                       plotOutput("hand_plot"))
  ),
  p("Oldfield, R.C. The assessment and analysis of handedness: the Edinburgh inventory. Neuropsychologia. 9(1):97-113. 1971.")
)