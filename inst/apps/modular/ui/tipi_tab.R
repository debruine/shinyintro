# http://gosling.psy.utexas.edu/scales-weve-developed/ten-item-personality-measure-tipi/ten-item-personality-inventory-tipi/
# Gosling, S. D., Rentfrow, P. J., & Swann, W. B., Jr. (2003). A Very Brief Measure of the Big Five Personality Domains. Journal of Research in Personality, 37, 504-528.

# scoring: 
# Extraversion: 1, 6R; 
# Agreeableness: 2R, 7; 
# Conscientiousness; 3, 8R; 
# Emotional Stability: 4R, 9; 
# Openness to Experiences: 5, 10R.

tipi_q <- list(
  E_01 = "Extraverted, enthusiastic",
  A_02 = "Critical, quarrelsome",
  C_03 = "Dependable, self-disciplined",
  S_04 = "Anxious, easily upset",
  O_05 = "Open to new experiences, complex",
  E_06 = "Reserved, quiet",
  A_07 = "Sympathetic, warm",
  C_08 = "Disorganized, careless",
  S_09 = "Calm, emotionally stable",
  O_10 = "Conventional, uncreative"
)

tipi_rev <- c("A_02", "S_04", "E_06", "C_08", "O_10")

tipi_opts <- c(
  "Disagree strongly" = 1,
  "Disagree moderately" = 2,
  "Disagree a little" = 3,
  "Neither agree nor disagree" = 4,
  "Agree a little" = 5,
  "Agree moderately" = 6,
  "Agree strongly" = 7
)

title <- "Ten-Item Personality Inventory"
instructions <- "Here are a number of personality traits that may or may not apply to you. Please select a phrase under each statement to indicate the extent to which you agree or disagree with that statement. You should rate the extent to which the pair of traits applies to you, even if one characteristic applies more strongly than the other."