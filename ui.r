library("shiny")
library("dplyr")
library("leaflet")
library("plotly")
source("map_data.r")
source("ocean_data.r")
source("causes_data.r")
library("bslib")

my_ui <- navbarPage(
  theme = bs_theme(bootswatch = "minty"),
  title = "A Global Analysis of Coral Reef Bleachings",
  id = "navbar",
  tabPanel("Introduction"),
  tabPanel("Map of Coral Reef Bleachings",
           h3("Coral Reef Bleachings around the World"),
           sidebarLayout(
             mainPanel(
               leafletOutput("bleaching_map")
             ),
             sidebarPanel(
               selectInput(
                 inputId = "user_interval",
                 label = "Select bleaching level:",
                 choices = reef_data$interval,
                 selected = "50 and above",
                 multiple = TRUE
               )
             )
           )
  ),
  tabPanel("Coral Reef Bleaching by Oceans",
           sidebarLayout(
             mainPanel(
               h3("Coral Reef Bleachings by Year in Different Oceans"),
               plotlyOutput("bleaching_oceans")
             ),
             sidebarPanel(
               checkboxGroupInput("ocean", "Select an ocean:",
                                  choices = unique(coral_reef_data$Ocean),
                                  selected = "Pacific"
               ),
               sliderInput("years", "Select a Range of Years:",
                           min = min(coral_reef_data$Year),
                           max = max(coral_reef_data$Year),
                           value = c(min(coral_reef_data$Year), max(coral_reef_data$Year)),
                           step = 1
               )
             )
           )
  ),
  tabPanel("Causes of Coral Reef Bleaching",
           sidebarLayout(
             mainPanel(
               h3("Impacts of Different Factors on Coral Reef Bleaching"),
               plotlyOutput("bleaching_factors")
             ),
             sidebarPanel(
               selectInput(
                 inputId = "factor",
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
  ),
  tabPanel("Conclusion")
)