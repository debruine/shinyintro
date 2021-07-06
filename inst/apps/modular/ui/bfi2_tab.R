# Soto, C. J., & John, O. P. (2017). Short and extra-short forms of the Big Five Inventory–2: The BFI-2-S and BFI- 2-XS. Journal of Research in Personality, 68, 69-81.

# Domain Scales
# Extraversion: 1R, 6, 11, 16, 21R, 26R 
# Agreeableness: 2, 7R, 12, 17R, 22, 27R 
# Conscientiousness: 3R, 8R, 13, 18, 23, 28R 
# Negative Emotionality: 4, 9, 14R, 19R, 24R, 29 
# Open-Mindedness: 5, 10R, 15, 20R, 25, 30R

rev <- c("E_01", "E_21", "E_26",
          "A_07", "A_17", "A_27", 
          "C_03", "C_08", "C_28", 
          "N_14", "N_19", "N_24", 
          "O_10", "O_20", "O_30")

bfi2_q <- list(
  E_01 = "Tends to be quiet.", 
  A_02 = "Is compassionate, has a soft heart.",
  C_03 = "Tends to be disorganized.",
  N_04 = "Worries a lot.",
  O_05 = "Is fascinated by art, music, or literature.",
  E_06 = "Is dominant, acts as a leader.", 
  A_07 = "Is sometimes rude to others.",
  C_08 = "Has difficulty getting started on tasks.",
  N_09 = "Tends to feel depressed, blue.",
  O_10 = "Has little interest in abstract ideas.",
  E_11 = "Is full of energy.", 
  A_12 = "Assumes the best about people.",
  C_13 = "Is reliable, can always be counted on.",
  N_14 = "Is emotionally stable, not easily upset.",
  O_15 = "Is original, comes up with new ideas.",
  E_16 = "Is outgoing, sociable.", 
  A_17 = "Can be cold and uncaring.",
  C_18 = "Keeps things neat and tidy.",
  N_19 = "Is relaxed, handles stress well.",
  O_20 = "Has few artistic interests.",
  E_21 = "Prefers to have others take charge.", 
  A_22 = "Is respectful, treats others with respect.",
  C_23 = "Is persistent, works until the task is finished.",
  N_24 = "Feels secure, comfortable with self.",
  O_25 = "Is complex, a deep thinker.",
  E_26 = "Is less active than other people.", 
  A_27 = "Tends to find fault with others.",
  C_28 = "Can be somewhat careless.",
  N_29 = "Is temperamental, gets emotional easily.",
  O_30 = "Has little creativity."
)

bfi2_opts <- c(
  "Disagree strongly" = 1,
  "Disagree a little" = 2,
  "Neutral; no opinion" = 3,
  "Agree a little" = 4,
  "Agree strongly" = 5
)

titla <- "Big Five Inventory"

instructions <- "Here are a number of characteristics that may or may not apply to you. For example, do you agree that you are someone who likes to spend time with others? Please choose a phrase for each statement to indicate the extent to which you agree or disagree with that statement."