# display debugging messages in R (if local) and in the console log
debug_msg <- function(...) {
  is_local <- Sys.getenv('SHINY_PORT') == ""
  txt <- toString(list(...))
  if (is_local) message(txt)
  shinyjs::runjs(sprintf("console.debug(\"%s\")", txt))
}

debug_sprintf <- function(fmt, ...) {
  debug_msg(sprintf(fmt, ...))
}

append_pet_data <- function(data, gs4 = TRUE) {
  data$datetime <- Sys.time()
  
  if (gs4) {
    sheet_append(SHEET_ID, data, "pet")
    sum_data <- read_sheet(SHEET_ID, "pet")
  } else {
    old_data <- read_csv("data/pet.csv")
    sum_data <- bind_rows(old_data, data)
    write_csv(sum_data, "data/pet.csv")
  }
  
  sum_data
}

append_food_data <- function(data, gs4 = TRUE) {
  data$datetime <- Sys.time()
  
  if (gs4) {
    sheet_append(SHEET_ID, data, "food")
    sum_data <- read_sheet(SHEET_ID, "food")
  } else {
    old_data <- read_csv("data/food.csv")
    sum_data <- bind_rows(old_data, data)
    write_csv(sum_data, "data/food.csv")
  }
  
  sum_data
}

make_pet_plot <- function(data) {
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


make_food_plot <- function(data) {
  data %>%
    # make answer a factor for empty categories
    mutate(answer = factor(answer, food_opts)) %>%
    # plot number of foods in each category
    ggplot(aes(x = answer, fill = answer)) +
    geom_bar(show.legend = FALSE, na.rm = TRUE) +
    scale_fill_viridis_d() +
    # keep empty categories, not NAs
    scale_x_discrete(drop = FALSE, na.translate = FALSE)
}

make_pet_summary_plot <- function(data, small_screen) {
  if (nrow(data) == 0) return()
  
  omit_vars <- c("session_id", "datetime")
  
  long_data <- data %>%
    pivot_longer(-(omit_vars), 
                 names_to = "pet", 
                 values_to = "pref")  %>%
    # get in same order as table
    mutate(pet = factor(pet, names(pet_q)))
  
  # plot distribution of pet preference in each category
  g <- ggplot(long_data, aes(x = pet, y = pref, color = pet)) +
    scale_color_viridis_d() + 
    scale_x_discrete(name = "") +
    scale_y_continuous(name = "Pet Preference", breaks = 1:9, limits = c(1, 9))
  
  # rotate x-axis text on small screens
  if (small_screen) {
    g <- g + theme(axis.text.x=element_text(angle=90,hjust=1))
  }
  
  if (nrow(data) == 1) {
    # violins don't work with 1 row
    g + geom_point(size = 10, show.legend = FALSE)
  } else {
    g + geom_violin(aes(fill = pet), alpha = 0.5, show.legend = FALSE) +
      scale_fill_viridis_d()
  }
}


make_food_summary_plot <- function(data, small_screen) {
  if (nrow(data) == 0) return()
  
  omit_vars <- c("session_id", "datetime")
  
  long_data <- data %>%
    pivot_longer(-(omit_vars),
                 names_to = "food",
                 values_to = "answer") %>%
    mutate(answer = factor(answer, food_opts))
  
  plot_cols <- ifelse(small_screen, 1, 2)
  
  # plot number of foods in each category
  ggplot(long_data, aes(x = answer, fill = answer)) +
    geom_bar(show.legend = FALSE, na.rm = TRUE) +
    scale_fill_viridis_d() +
    facet_wrap(~food, ncol = plot_cols) +
    scale_x_discrete(drop = FALSE, na.translate = FALSE)
}