# http://gosling.psy.utexas.edu/scales-weve-developed/ten-item-personality-measure-tipi/ten-item-personality-inventory-tipi/

# scoring: 
# Extraversion: 1, 6R; 
# Agreeableness: 2R, 7; 
# Conscientiousness; 3, 8R; 
# Emotional Stability: 4R, 9; 
# Openness to Experiences: 5, 10R.

tipi_q <- list(
  E_1 = "Extraverted, enthusiastic",
  A_2 = "Critical, quarrelsome",
  C_3 = "Dependable, self-disciplined",
  S_4 = "Anxious, easily upset",
  O_5 = "Open to new experiences, complex",
  E_6 = "Reserved, quiet",
  A_7 = "Sympathetic, warm",
  C_8 = "Disorganized, careless",
  S_9 = "Calm, emotionally stable",
  O_10 = "Conventional, uncreative"
)

tipi_rev <- c("A_2", "S_4", "E_6", "C_8", "O_10")

tipi_opts <- c(
  "Disagree strongly" = 1,
  "Disagree moderately" = 2,
  "Disagree a little" = 3,
  "Neither agree nor disagree" = 4,
  "Agree a little" = 5,
  "Agree moderately" = 6,
  "Agree strongly" = 7
)

# tipi_tab ----
tipi_tab <- tabItem(
  tabName = "tipi_tab",
  h3("Ten-Item Personality Inventory"),
  p("Here are a number of personality traits that may or may not apply to you. Please select a phrase under each statement to indicate the extent to which you agree or disagree with that statement. You should rate the extent to which the pair of traits applies to you, even if one characteristic applies more strongly than the other."),
  tabsetPanel(id = "tipi_tabset",
              tabPanel("Questionnaire", 
                       radioTableInput("tipi_table", tipi_q, tipi_opts, tipi_rev),
                       actionButton("tipi_submit", "Submit")),
              tabPanel("Feedback",plotOutput("tipi_plot"))
  ),
  p("Gosling, S. D., Rentfrow, P. J., & Swann, W. B., Jr. (2003). A Very Brief Measure of the Big Five Personality Domains. Journal of Research in Personality, 37, 504-528.")
)