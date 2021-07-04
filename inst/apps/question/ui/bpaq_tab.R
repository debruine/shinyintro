# https://www.psytoolkit.org/survey-library/aggression-buss-perry.html

bpaq_q <- list(
  bpaq_P_1 =  "Once in a while I can't control the urge to strike another person.",
  bpaq_P_2 = "Given enough provocation, I may hit another person.",
  bpaq_P_3 = "If somebody hits me, I hit back.",
  bpaq_P_4 = "I get into fights a little more than the average person.",
  bpaq_P_5 = "If I have to resort to violence to protect my rights, I will.",
  bpaq_P_6 = "There are people who pushed me so far that we came to blows.",
  bpaq_P_7 = "I can think of no good reason for ever hitting a person.",
  bpaq_P_8 = "I have threatened people I know.",
  bpaq_P_9 = "I have become so mad that I have broken things.",
  bpaq_V_10 = "I tell my friends openly when I disagree with them.",
  bpaq_V_11 = "I often find myself disagreeing with people.",
  bpaq_V_12 = "When people annoy me, I may tell them what I think of them.",
  bpaq_V_13 = "I can't help getting into arguments when people disagree with me.",
  bpaq_V_14 = "My friends say that I'm somewhat argumentative.",
  bpaq_A_15 = "I flare up quickly but get over it quickly.",
  bpaq_A_16 = "When frustrated, I let my irritation show.",
  bpaq_A_17 = "I sometimes feel like a powder keg ready to explode.",
  bpaq_A_18 = "I am an even-tempered person.",
  bpaq_A_19 = "Some of my friends think I'm a hothead.",
  bpaq_A_20 = "Sometimes I fly off the handle for no good reason.",
  bpaq_A_21 = "I have trouble controlling my temper.",
  bpaq_H_22 = "I am sometimes eaten up with jealousy.",
  bpaq_H_23 = "At times I feel I have gotten a raw deal out of life.",
  bpaq_H_24 = "Other people always seem to get the breaks.",
  bpaq_H_25 = "I wonder why sometimes I feel so bitter about things.",
  bpaq_H_26 = "I know that \"friends\" talk about me behind my back.",
  bpaq_H_27 = "I am suspicious of overly friendly strangers.",
  bpaq_H_28 = "I sometimes feel that people are laughing at me behind my back.",
  bpaq_H_29 = "When people are especially nice, I wonder what they want."
)

bpaq_rev <- c("bpaq_A_18", "bpaq_P_7")

bpaq_opts <- c(
  "Extremely Uncharacteristic" = 1,
  "Somewhat Uncharacteristic" = 2,
  "Neither Uncharacteristic Nor Characteristic" = 3,
  "Somewhat Characteristic" = 4,
  "Extremely Characteristic" = 5
)

# bpaq_tab ----
bpaq_tab <- tabItem(
  tabName = "bpaq_tab",
  h3("Buss Perry Aggression Questionnaire"),
  p("Using this 5 point scale, indicate how uncharacteristic or characteristic each of the following statements is in describing you."),
  tabsetPanel(id = "bpaq_tabset",
              tabPanel("Questionnaire", 
                       radioTableInput("bpaq_table", bpaq_q, bpaq_opts, bpaq_rev, q_width = "40%"),
                       actionButton("bpaq_submit", "Submit")),
              tabPanel("Feedback", plotOutput("bpaq_plot"))
  ),
  p("AH Buss & MP Perry. The Aggression Questionnaire. 63 J Pers Soc Psychol 452-459. 1992.")
)