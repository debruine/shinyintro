# Domain Scales
# Extraversion: 1R, 6, 11, 16, 21R, 26R 
# Agreeableness: 2, 7R, 12, 17R, 22, 27R 
# Conscientiousness: 3R, 8R, 13, 18, 23, 28R 
# Negative Emotionality: 4, 9, 14R, 19R, 24R, 29 
# Open-Mindedness: 5, 10R, 15, 20R, 25, 30R

bfi2_rev <- c("bfi2_E_1", "bfi2_E_21", "bfi2_E_26",
              "bfi2_A_7", "bfi2_A_17", "bfi2_A_27", 
              "bfi2_C_3", "bfi2_C_8", "bfi2_C_28", 
              "bfi2_N_14", "bfi2_N_19", "bfi2_N_24", 
              "bfi2_O_10", "bfi2_O_20", "bfi2_O_30")

bfi2_q <- list(
  bfi2_E_1 = "Tends to be quiet.", 
  bfi2_A_2 = "Is compassionate, has a soft heart.",
  bfi2_C_3 = "Tends to be disorganized.",
  bfi2_N_4 = "Worries a lot.",
  bfi2_O_5 = "Is fascinated by art, music, or literature.",
  bfi2_E_6 = "Is dominant, acts as a leader.", 
  bfi2_A_7 = "Is sometimes rude to others.",
  bfi2_C_8 = "Has difficulty getting started on tasks.",
  bfi2_N_9 = "Tends to feel depressed, blue.",
  bfi2_O_10 = "Has little interest in abstract ideas.",
  bfi2_E_11 = "Is full of energy.", 
  bfi2_A_12 = "Assumes the best about people.",
  bfi2_C_13 = "Is reliable, can always be counted on.",
  bfi2_N_14 = "Is emotionally stable, not easily upset.",
  bfi2_O_15 = "Is original, comes up with new ideas.",
  bfi2_E_16 = "Is outgoing, sociable.", 
  bfi2_A_17 = "Can be cold and uncaring.",
  bfi2_C_18 = "Keeps things neat and tidy.",
  bfi2_N_19 = "Is relaxed, handles stress well.",
  bfi2_O_20 = "Has few artistic interests.",
  bfi2_E_21 = "Prefers to have others take charge.", 
  bfi2_A_22 = "Is respectful, treats others with respect.",
  bfi2_C_23 = "Is persistent, works until the task is finished.",
  bfi2_N_24 = "Feels secure, comfortable with self.",
  bfi2_O_25 = "Is complex, a deep thinker.",
  bfi2_E_26 = "Is less active than other people.", 
  bfi2_A_27 = "Tends to find fault with others.",
  bfi2_C_28 = "Can be somewhat careless.",
  bfi2_N_29 = "Is temperamental, gets emotional easily.",
  bfi2_O_30 = "Has little creativity."
)

bfi2_opts <- c(
  "Disagree strongly" = 1,
  "Disagree a little" = 2,
  "Neutral; no opinion" = 3,
  "Agree a little" = 4,
  "Agree strongly" = 5
)

# bfi2_tab ----
bfi2_tab <- tabItem(
  tabName = "bfi2_tab",
  h3("Big Five Inventory"),
  p("Here are a number of characteristics that may or may not apply to you. For example, do you agree that you are someone who likes to spend time with others? Please choose a phrase for each statement to indicate the extent to which you agree or disagree with that statement."),
  tabsetPanel(id = "bfi2_tabset",
              tabPanel("Questionnaire", 
                       radioTableInput("bfi2_table", bfi2_q, bfi2_opts, bfi2_rev, "35%"),
                       actionButton("bfi2_submit", "Submit")),
              tabPanel("Feedback", plotOutput("bfi2_plot"))
  ),
  p("Soto, C. J., & John, O. P. (2017). Short and extra-short forms of the Big Five Inventory–2: The BFI-2-S and BFI- 2-XS. Journal of Research in Personality, 68, 69-81.")
)