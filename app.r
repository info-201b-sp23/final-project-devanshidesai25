install.packages("shiny")
library(shiny)
source("ui.r")
source("server.r")

# Runs the application (both ui and server)
shinyApp(ui = my_ui, server = my_server)

