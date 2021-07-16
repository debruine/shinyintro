report_tab <- tabItem(
  tabName = "report_tab",
  box(id = "download_box", title = "Downloads", solidHeader = TRUE,
      downloadButton("pet_data_dl", "Pets Data"),
      downloadButton("food_data_dl", "Food Data"),
      downloadButton("pet_plot_dl", "Pets Plot"),
      downloadButton("food_plot_dl", "Food Plot"),
      numericInput("plot_width", "Plot Width (inches)", 7, min = 1, max = 10),
      numericInput("plot_height", "Plot Height (inches)", 5, min = 1, max = 10),
      downloadButton("pet_report_dl", "Pets Report"),
      downloadButton("food_report_dl", "Food Report")
  )
)