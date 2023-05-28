library("shiny")
library("dplyr")
library("leaflet")
library("plotly")
source("map_data.r")
source("ocean_data.r")
source("causes_data.r")
library("bslib")

my_ui <- navbarPage(
  title = "A Global Analysis of Coral Reef Bleachings",
  id = "navbar",
  tabPanel("Introduction",
           fluidPage(
             titlePanel("Welcome to A Global Analysis of Coral Reef Bleachings"),
             sidebarLayout(
               sidebarPanel(
                 h3("Overview"),
                 p("Welcome to the \"A Global Analysis of Coral Reef Bleachings\" project, an interactive exploration of coral reef health and the factors contributing to bleaching events worldwide. This project aims to answer key questions about the extent, causes, and geographical distribution of coral reef bleachings. By analyzing and visualizing relevant data, we strive to deepen our understanding of these critical marine ecosystems and raise awareness for their conservation."),
                 h3("Key Questions"),
                 tags$ol(
                   tags$li("What is the global extent of coral reef bleachings?"),
                   tags$li("How do different oceans vary in terms of coral reef bleachings?"),
                   tags$li("What are the main factors causing coral reef bleachings?"),
                   tags$li("How has the severity of coral reef bleachings changed over time?")
                 ),
                 h3("Data Sources"),
                 p("To answer these questions, we utilize multiple datasets:"),
                 tags$ol(
                   tags$li(
                     tags$strong("Coral Reef Bleaching Data:"), " Source: [INSERT DATA SOURCE URL]",
                     p("This dataset provides information on the occurrence and severity of coral reef bleachings across different regions and time periods. It includes data on bleaching levels, geographical coordinates of reef locations, and additional attributes.")
                   ),
                   tags$li(
                     tags$strong("Oceanic Data:"), " Source: [INSERT DATA SOURCE URL]",
                     p("This dataset contains information on various oceans, including their boundaries, characteristics, and ecological factors that may influence coral reef health.")
                   ),
                   tags$li(
                     tags$strong("Causes of Coral Reef Bleaching:"), " Source: [INSERT DATA SOURCE URL]",
                     p("This dataset offers insights into the primary causes of coral reef bleachings, such as human impact, dynamite fishing, pollution, and other factors. It includes data on the frequency and severity of each cause over time.")
                   )
                 ),
                 h3("Ethical Considerations and Limitations"),
                 p("When working with such data, it is important to acknowledge and address ethical considerations and limitations:"),
                 tags$ol(
                   tags$li(
                     tags$strong("Data Privacy and Consent:"), 
                     " It is crucial to ensure that the data used in this project adheres to appropriate privacy guidelines and has been obtained with proper consent from relevant stakeholders."
                   ),
                   tags$li(
                     tags$strong("Representativeness and Bias:"), 
                     " The available data may not capture the entire spectrum of coral reef bleachings worldwide, potentially leading to biases and limitations in our analysis. It is important to interpret the results while considering the representativeness of the dataset."
                   ),
                   tags$li(
                     tags$strong("Data Accuracy and Quality:"), 
                     " Although efforts have been made to ensure data accuracy, there may still be errors or discrepancies present. Additionally, variations in data quality and collection methods across different sources may impact the reliability of the analysis."
                   )
                 )
               ),
               mainPanel(
                 h3("Image Placeholder"),
                 tags$img(src = "https://media.cnn.com/api/v1/images/stellar/prod/200407132036-03-great-barrier-reef-bleaching-04-07.jpg?q=x_5,y_259,h_1441,w_2561,c_crop/h_720,w_1280/f_webp", width = "100%")
               )
             )
           )
  ),
  
  
  
  
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