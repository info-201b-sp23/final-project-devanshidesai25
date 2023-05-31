install.packages("shiny")
library(shiny)
source("/Users/yijunye/Desktop/UW/INFO201/final-project-devanshidesai25/ui.r")
source("/Users/yijunye/Desktop/UW/INFO201/final-project-devanshidesai25/server.r")

coral_reef_data <- read.csv("/Users/yijunye/Desktop/UW/INFO201/final-project-devanshidesai25/raw_reef_check_data.csv")
# Runs the application (both ui and server)
shinyApp(ui = my_ui, server = my_server)

