# http://www.brainmapping.org/shared/Edinburgh.php
# Oldfield, R.C. The assessment and analysis of handedness: the Edinburgh inventory. Neuropsychologia. 9(1):97-113. 1971.

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
#names(hand_q) <- paste0("hand_", seq_along(hand_q))

hand_opts <- c(
  "Always Left" = 1,
  "Usually Left" = 2,
  "No Preference" = 3,
  "Usually Right" = 4,
  "Always Right" = 5
)

hand_tab <- questUI("hand", "Edinburgh Handedness Inventory", 
                    "Which hand do you prefer to use when:", 
                    hand_q, hand_opts, q_width = "40%")

hand_plot <- function(data) {
  data %>%
    filter(answer != "") %>%
    mutate(answer = factor(answer, 1:5, names(hand_opts))) %>%
    count(answer, .drop = FALSE) %>%
    ggplot(aes(x = answer, y = n, fill = answer)) +
      geom_col() +
      scale_fill_viridis_d(drop = FALSE) +
      scale_x_discrete(name = "", drop = FALSE) +
      scale_y_continuous(name = "", breaks = 0:15, limits = c(0, 15)) +
      theme(legend.position = "none")
}

hand_summary <- function(data) {
  #data <- read_sheet(SHEET_ID, "hand")
  
  sumdat <- data %>%
    # one entry per subject
    group_by(session_id) %>%
    filter(row_number() == 1) %>%
    ungroup() %>%
    # make long
    pivot_longer(starts_with("hand"),
                 names_to = "question",
                 values_to = "answer") %>%
    filter(answer != "") %>%
    mutate(answer = factor(answer, 1:5, names(hand_opts))) %>%
    count(session_id, answer, .drop = FALSE) %>%
    # calculate dot size; scale from 2 to 10
    group_by(answer, n) %>%
    mutate(size = n()) %>%
    ungroup() %>%
    mutate(size = size/max(size) * 8 + 2)
  
    # plot distribution of handedness
    ggplot(sumdat, aes(x = answer, y = n, color = answer)) +
      geom_line(aes(group = session_id), color = "grey") +
      geom_point(aes(size = I(size))) +
      scale_color_viridis_d(drop = FALSE) +
      scale_x_discrete(name = "", drop = FALSE) +
      scale_y_continuous(name = "", breaks = 0:15, limits = c(0, 15)) +
      theme(legend.position = "none")
}
