# http://gosling.psy.utexas.edu/scales-weve-developed/ten-item-personality-measure-tipi/ten-item-personality-inventory-tipi/

q <- list(
  "Extraverted, enthusiastic",
  "Critical, quarrelsome",
  "Dependable, self-disciplined",
  "Anxious, easily upset",
  "Open to new experiences, complex",
  "Reserved, quiet",
  "Sympathetic, warm",
  "Disorganized, careless",
  "Calm, emotionally stable",
  "Conventional, uncreative"
)

a <- c(
  "",
  "Disagree strongly" = 1,
  "Disagree moderately" = 2,
  "Disagree a little" = 3,
  "Neither agree nor disagree" = 4,
  "Agree a little" = 5,
  "Agree moderately" = 6,
  "Agree strongly" = 7
)

# scoring: 
# Extraversion: 1, 6R; 
# Agreeableness: 2R, 7; 
# Conscientiousness; 3, 8R; 
# Emotional Stability: 4R, 9; 
# Openness to Experiences: 5, 10R.

# tipi_tab ----
tipi_tab <- tabItem(
  tabName = "tipi_tab",
  h3("Ten-Item Personality Inventory"),
  p("Here are a number of personality traits that may or may not apply to you. Please select a phrase under each statement to indicate the extent to which you agree or disagree with that statement. You should rate the extent to which the pair of traits applies to you, even if one characteristic applies more strongly than the other."),
  selectInput("q1", q[1], choices = a),
  selectInput("q2", q[2], choices = a),
  selectInput("q3", q[3], choices = a),
  selectInput("q4", q[4], choices = a),
  selectInput("q5", q[5], choices = a),
  selectInput("q6", q[6], choices = a),
  selectInput("q7", q[7], choices = a),
  selectInput("q8", q[8], choices = a),
  selectInput("q9", q[9], choices = a),
  selectInput("q10", q[10], choices = a),
  actionButton("q_submit", "Submit")
)