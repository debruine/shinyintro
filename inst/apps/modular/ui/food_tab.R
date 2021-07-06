### food_tab ----

food_q <- c(
  apple = "Apples 🍎",
  banana = "Bananas 🍌",
  carrot = "Carrots 🥕",
  donut = "Donuts 🍩",
  eggplant = "Eggplants 🍆"
)

food_opts <- c(
  "Hate it",
  "Dislike it", 
  "Meh",
  "Like it",
  "Love it"
)

food_tab <- questUI("food", "Food Questionnaire", 
                    "How much do you like each food?", 
                    food_q, food_opts)

food_plot <- function(data) {
  data %>%
    # make answer a factor for empty categories
    mutate(answer = factor(answer, food_opts)) %>%
    # plot number of foods in each category
    ggplot(aes(x = answer, fill = answer)) +
    geom_bar(show.legend = FALSE, na.rm = TRUE) +
    scale_fill_viridis_d() +
    # keep empty categories, not NAs
    scale_x_discrete(drop = FALSE, na.translate = FALSE) +
    scale_y_continuous(limits = c(0, length(food_q)))
}

food_summary <- function(data, small_screen = FALSE) {
  sumdata <- data %>%
    pivot_longer(-c("session_id", "datetime"),
                 names_to = "food",
                 values_to = "answer") %>%
    mutate(answer = factor(answer, food_opts))
  
  plot_cols <- ifelse(small_screen, 1, 2)
  
  # plot number of foods in each category
  ggplot(sumdata, aes(x = answer, fill = answer)) +
    geom_bar(show.legend = FALSE, na.rm = TRUE) +
    scale_fill_viridis_d() +
    facet_wrap(~food, ncol = plot_cols) +
    scale_x_discrete(drop = FALSE, na.translate = FALSE)
}