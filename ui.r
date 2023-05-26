library("shiny")
library("dplyr")
library("leaflet")
library("plotly")
source("map_data.r")
source("ocean_data.r")

my_ui <- navbarPage(
  title = "A Global Analysis of Coral Reef Bleachings",
  id = "navbar",
  
  tabPanel("Introduction"),
  
  tabPanel("Map of Coral Reef Bleachings",
           leafletOutput("bleaching_map"),
           selectInput(
             inputId = "user_interval",
             label = "Bleaching Level",
             choices = reef_data$interval,
             selected = "50 and above",
             multiple = TRUE
           )
  ),
  tabPanel("Coral Reef Bleaching by Oceans",
           plotlyOutput("bleaching_oceans"),
           selectInput("ocean", "Select an Ocean:",
                       choices = unique(coral_reef_data$Ocean)
            ), 
           sliderInput("years", "Select a Range of Years:",
                       min = min(coral_reef_data$Year),
                       max = max(coral_reef_data$Year),
                       value = c(min(coral_reef_data$Year), max(coral_reef_data$Year)),
                       step = 1)
  )

)