library("shiny")
library("dplyr")
library("leaflet")
library("plotly")
source("map_data.r")
source("ocean_data.r")
source("causes_data.r")

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
           checkboxGroupInput("ocean", "Select an Ocean:",
                       choices = unique(coral_reef_data$Ocean),
                       selected = "Pacific"
                       
            ), 
           sliderInput("years", "Select a Range of Years:",
                       min = min(coral_reef_data$Year),
                       max = max(coral_reef_data$Year),
                       value = c(min(coral_reef_data$Year), max(coral_reef_data$Year)),
                       step = 1)
  ),
  tabPanel("Main Causes of Coral Reef Bleaching",
           plotlyOutput("bleaching_factors"),
           selectInput(
             inputId= "factor",
             label = "Bleaching Causes",
             choices = c("HumanImpact", "Dynamite", "Poison", "Sewage", "Commercial", "Industrial"),
             selected = "HumanImpact",
             multiple = FALSE
           ),
           selectInput(
             inputId = "level",
             label = "Level of Impact",
             choices = c("low", "moderate", "high"),
             selected = "moderate",
             multiple = FALSE
           )
  )
    

)