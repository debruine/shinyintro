header <- dashboardHeader(
  title = "Template",
  # statuses: primary, success, info, warning, danger
  dropdownMenu(
    type = "messages",  badgeStatus = "primary",
    messageItem("Welcome",
                "Welcome to the template app",
                time = "today"
    )
  ),
  dropdownMenu(
    type = "notifications", badgeStatus = "primary",
    notificationItem(icon = icon("users"), status = "info",
                     "5 new members joined today"
    )
  ),
  dropdownMenu(
    type = "tasks", badgeStatus = "primary",
    taskItem(value = 50, color = "red",
             "Write documentation"
    )
  )
)