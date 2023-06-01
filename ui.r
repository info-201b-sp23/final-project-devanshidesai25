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
                     tags$strong("NOAA Reef Check & Coral Bleaching Data:"), " Source: [https://www.kaggle.com/datasets/oasisdata/noaa-reef-check-coral-bleaching-data]",
                     p("The first dataset that we will be using is from the National Oceanic and Atmospheric Administration (NOAA), and is published on the website, Kaggle. This data was collected by the NOAA’s Coral Reef Watch program, which uses remote sensing and satellite technology to monitor coral reef ecosystems around the world, so that they can better understand the effects of climate change and other environmental factors on the health of coral reefs.")
                   ),
                   tags$li(
                     tags$strong("raw_reef_check_data:"), " Source: [https://github.com/InstituteForGlobalEcology/Coral-bleaching-a-global-analysis-of-the-past-two-decades/tree/master]",
                     p("The second dataset that we are using is from Institute For Global Ecoclogy. The dataset showing us the analysis of coral bleaching of the past two decades. It includes data on the frequency and severity of each cause over time.")
                   ),
                   tags$li(
                     tags$strong("reefs_with_coordinates:"), " Source: [https://www.reefcheck.org]",
                     p("The third dataset that we are using is from Reef Check, which is an organization of professional scientists who collect data at coral reef sites and measure evironmental factors such as water temperature, acidification, etc. as well as how many coral colonies are bleached. There are 9,215 data observations in this data set ranging from the years 1998 to 2017.")
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
  
  
  
  
  tabPanel(
    "Map of Coral Reef Bleachings",
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
    ),
    p(" "),
    p("By creating this visualization, we aimed to understand what areas were most 
      affected by coral reef bleachings. In the widget, you can choose different levels 
      of bleaching. Each dot on the map is a coral reef colony, and the levels indicate 
      the number of corals in the colony that have been affected, such as less than ten 
      colonies or fifty or above colonies."),
    p("By visualizing which areas and reefs are most affected by coral bleaching, 
      we can begin to understand possible reasons for coral bleaching. For example, 
      areas with higher temperatures and higher risks of global warming, such as areas 
      closer to the equator, have higher bleaching levels and more colonies that 
      have experienced bleaching, because increased water temperatures are a 
      significant cause of coral bleaching. Another significant factor in coral 
      bleaching is human impacts, such as sewage leaks, poison leaks, tourism, 
      and water activities. Our visualization of the affected areas can give us a 
      good idea of which countries and locations are contributing the most to 
      coral bleaching.")
  ),
  tabPanel("Coral Reef Bleaching by Oceans",
           h3("Coral Reef Bleachings by Year in Different Oceans"),
           sidebarLayout(
             mainPanel(
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
           ),
           p("By creating this visualization, we aimed to understand in which oceans 
           are coral reef bleaching most frequent, and how has this changed over time. 
           By understanding which oceans have the highest bleaching frequencies, we 
           can understand the underlying causes of bleaching and how things like water 
           temperature, storms, and other human activities in nearby places are 
           affecting the coral reefs, and how these factors have all changed over time.")
  ),
  tabPanel("Causes of Coral Reef Bleaching",
           h3("Impacts of Different Factors on Coral Reef Bleaching"),
           sidebarLayout(
             mainPanel(
               plotlyOutput("bleaching_factors")
             ),
             sidebarPanel(
               selectInput(
                 inputId = "factor",
                 label = "Bleaching Causes",
                 choices = c("HumanImpact", "Dynamite", "Poison", "Sewage", 
                             "Commercial", "Industrial"),
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
           ),
           p("In this chart, we display how many coral reefs are affected by each of 
           the bleaching causes, from direct human impact, sewage, poison, and other 
           causes, and how the numbers have changed over time. We can also see how 
           many bleachings have occurred by high, moderate, and low levels of each 
           of these factors. By understanding this, we can see trends in these causes 
           and learn how human based factors affect coral bleaching events around 
           the world. It is important to know this information so that we can then 
           work towards minimizing our impact.")
  ),
  tabPanel("Conclusion",
           fluidPage(
             titlePanel("Conclusion and Recommendations"),
             sidebarLayout(
               sidebarPanel(
                 uiOutput(outputId = "variable")
               ),
               mainPanel(
                uiOutput(outputId = "question"))),
           )
  )
)
  