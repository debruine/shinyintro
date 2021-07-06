# https://www.psytoolkit.org/survey-library/aggression-buss-perry.html
# AH Buss & MP Perry. The Aggression Questionnaire. 63 J Pers Soc Psychol 452-459. 1992.

bpaq_q <- list(
  P_01 =  "Once in a while I can't control the urge to strike another person.",
  P_02 = "Given enough provocation, I may hit another person.",
  P_03 = "If somebody hits me, I hit back.",
  P_04 = "I get into fights a little more than the average person.",
  P_05 = "If I have to resort to violence to protect my rights, I will.",
  P_06 = "There are people who pushed me so far that we came to blows.",
  P_07 = "I can think of no good reason for ever hitting a person.",
  P_08 = "I have threatened people I know.",
  P_09 = "I have become so mad that I have broken things.",
  V_10 = "I tell my friends openly when I disagree with them.",
  V_11 = "I often find myself disagreeing with people.",
  V_12 = "When people annoy me, I may tell them what I think of them.",
  V_13 = "I can't help getting into arguments when people disagree with me.",
  V_14 = "My friends say that I'm somewhat argumentative.",
  A_15 = "I flare up quickly but get over it quickly.",
  A_16 = "When frustrated, I let my irritation show.",
  A_17 = "I sometimes feel like a powder keg ready to explode.",
  A_18 = "I am an even-tempered person.",
  A_19 = "Some of my friends think I'm a hothead.",
  A_20 = "Sometimes I fly off the handle for no good reason.",
  A_21 = "I have trouble controlling my temper.",
  H_22 = "I am sometimes eaten up with jealousy.",
  H_23 = "At times I feel I have gotten a raw deal out of life.",
  H_24 = "Other people always seem to get the breaks.",
  H_25 = "I wonder why sometimes I feel so bitter about things.",
  H_26 = "I know that \"friends\" talk about me behind my back.",
  H_27 = "I am suspicious of overly friendly strangers.",
  H_28 = "I sometimes feel that people are laughing at me behind my back.",
  H_29 = "When people are especially nice, I wonder what they want."
)

# reverse-coded ----
bpaq_rev <- c("A_18", "P_07")

# options ----
bpaq_opts <- c(
  "Extremely Uncharacteristic" = 1,
  "Somewhat Uncharacteristic" = 2,
  "Neither Uncharacteristic Nor Characteristic" = 3,
  "Somewhat Characteristic" = 4,
  "Extremely Characteristic" = 5
)

# set up tab ----
bpaq_tab <- questUI("bpaq", "Buss Perry Aggression Questionnaire", 
                    "Using this 5 point scale, indicate how uncharacteristic or characteristic each of the following statements is in describing you.", 
                    bpaq_q, bpaq_opts, reverse = bpaq_rev, q_width = "40%")

# individual plot function ----
bpaq_plot <- function(data) {
  data %>%
    separate(question, c("category", "n"), sep = "_") %>%
    mutate(category = factor(category, c("P", "V", "A", "H"), 
                             c("Physical", 
                               "Verbal", 
                               "Angry", 
                               "Hostile"))) %>%
    group_by(category) %>%
    summarise(score = mean(answer, na.rm = TRUE), .groups = "drop") %>%
    ggplot(aes(x = category, y = score, fill = category)) +
      geom_col(show.legend = FALSE) +
      scale_fill_viridis_d() +
      scale_y_continuous(name = "Average Score", limits = c(0, 5), breaks = 1:5) +
      scale_x_discrete(name = "Aggression Category")
}

# summary plot function ----
bpaq_summary <- function(data) {
  data <- read_sheet(SHEET_ID, "bpaq")
  
  sumdat <- data %>%
    pivot_longer(-c("session_id", "datetime"),
                 names_to = c("category", "n"), 
                 names_sep = "_",
                 values_to = "answer") %>%
    mutate(category = factor(category, c("P", "V", "A", "H"), 
                             c("Physical", 
                               "Verbal", 
                               "Angry", 
                               "Hostile"))) %>%
    group_by(session_id, category) %>%
    summarise(score = mean(answer, na.rm = TRUE), .groups = "drop")
  
  # plot 
  g <- ggplot(sumdat, aes(x = category, y = score, color = category)) +
    scale_color_viridis_d() +
    scale_y_continuous(name = "Average Score", limits = c(0, 5), breaks = 1:5) +
    scale_x_discrete(name = "Aggression Category")
  
  if (nrow(data) < 100) {
    # scale between 10 and 2 depending on nrow(data)
    size <- max((100 - nrow(data))/10, 2)
    # increase jitter width with nrow(data) max .5
    w <- nrow(data)/200
    g + geom_jitter(height = 0, width = w, size = size, show.legend = FALSE)
  } else {
    g + geom_violin(show.legend = FALSE)
  }
}