### pet_tab ----

pet_q <- list(
  dogs = "Dogs 🐕",
  cats = "Cats 🐈",
  birds = "Birds 🦜",
  fish = "Fish 🐠",
  mice = "Mice 🐁",
  hedgehogs = "Hedgehogs 🦔",
  snakes = "Snakes 🐍"
)

pet_opts <- c(
  "😨" = 1,
  "☹️" = 2,
  "🙁" = 3,
  "😕" = 4,
  "😐" = 5,
  "🙂" = 6,
  "😀" = 7,
  "😃" = 8,
  "😍" = 9
)

pet_tab <- questUI("pet", "Pet Questionnaire", 
                    "How much do you like each pet?", 
                    pet_q, pet_opts)

pet_plot <- function(data) { 
  data %>%
    # to handle when all are NA
    mutate(answer = as.numeric(answer)) %>%
    # get in same order as table
    mutate(question = factor(question, names(pet_q))) %>%
    ggplot(aes(x = question, y = answer, color = question)) +
      geom_point(size = 10, show.legend = FALSE, na.rm = TRUE) +
      scale_color_viridis_d() + 
      scale_x_discrete(name = "") +
      scale_y_continuous(name = "Pet Preference", breaks = 1:9, limits = c(1, 9))
}

pet_summary <- function(data, small_screen = FALSE) {
  sumdata <- data %>%
    select(-datetime) %>%
    pivot_longer(-c("session_id"), 
                 names_to = "pet", 
                 values_to = "pref")  %>%
    # get in same order as table
    mutate(pet = factor(pet, names(pet_q)))

  # plot distribution of pet preference in each category
  g <- ggplot(sumdata, aes(x = pet, y = pref, fill = pet)) +
    scale_fill_viridis_d() + 
    scale_x_discrete(name = "") +
    scale_y_continuous(name = "Pet Preference", breaks = 1:9, limits = c(1, 9))
  
  # rotate x-axis text on small screens
  if (small_screen) {
     g <- g + theme(axis.text.x=element_text(angle=90,hjust=1))
  }
  
  if (nrow(data) < 10) {
    g + geom_dotplot(binaxis = "y", stackdir = "center", binwidth = 0.5)
  } else {
    g + geom_violin(alpha = 0.5, show.legend = FALSE)
  }
}