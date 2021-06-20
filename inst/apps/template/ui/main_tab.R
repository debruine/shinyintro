# main_tab ----
main_tab <- tabItem(
  tabName = "main_tab",
  h2("Main"),
  box(id = "flower_box", title = "Flower", collapsible = T,
      HTML("<img src='img/flower.jpg' width = '100%'>")
  ),
  actionButton("show_flower", "Show Flower"),
  actionButton("hide_flower", "Hide Flower")
)