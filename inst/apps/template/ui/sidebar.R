sidebar <- dashboardSidebar(
  # https://fontawesome.com/icons?d=gallery&m=free
  sidebarMenu(
    id = "tabs",
    menuItem("Main", tabName = "main_tab",
             icon = icon("home")),
    menuItem("Info", tabName = "info_tab",
             icon = icon("info"))
  ),
  actionButton("say_hi", "Say Hi")
)
