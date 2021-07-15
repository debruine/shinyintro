logo_image <- function(change) {
  odd_clicks <- change%%2 == 1
  src <- ifelse(odd_clicks, 
                "www/img/shinyintro.png", 
                "www/img/psyteachr.png")
  
  list(src = src,
       width = "300px",
       height = "300px",
       alt = "ShinyIntro hex logo")
}