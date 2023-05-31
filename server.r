source("map_data.r")
source("ocean_data.r")
source("causes_data.r")
library("dplyr")
library("plotly")
library("leaflet")
library("tidyr")
library("rlang")

#Load Dataset
coral_reef_data <- read.csv("raw_reef_check_data.csv")
coral_bleaching_data <- read.csv("NOAA_Reef_Check__Bleaching_Data.csv")

#Summary data
#Variable 1: Year with most average bleaching
bleaching_by_year <- coral_reef_data %>% 
  group_by(Year) %>% 
  summarise(total_average_bleaching = sum(Average_bleaching))

highest_bleaching_year <- bleaching_by_year %>% 
  filter(total_average_bleaching == max(total_average_bleaching)) %>% 
  pull(Year)

#Variable 2: Average bleaching in the highest year
highest_year_average_bleaching <- bleaching_by_year %>% 
  filter(total_average_bleaching == max(total_average_bleaching)) %>% 
  pull(total_average_bleaching)

#Variable 3: Ocean with most average bleaching 
bleaching_by_ocean <- coral_reef_data %>% 
  group_by(Ocean) %>%
  filter(Ocean != "") %>%
  summarise(total_average_bleaching = sum(Average_bleaching))

ocean_highest_bleaching <- bleaching_by_ocean %>% 
  filter(total_average_bleaching == max(total_average_bleaching)) %>% 
  pull(Ocean)

#Variable 4: Average bleaching in the highest ocean
highest_ocean_average_bleaching <- bleaching_by_ocean %>% 
  filter(total_average_bleaching == max(total_average_bleaching)) %>% 
  pull(total_average_bleaching)

formatted_highest_ocean_average_bleaching <- format(highest_ocean_average_bleaching, scientific = FALSE)

#Variable 5: Reef with the most average bleaching 
bleaching_by_reef <- coral_reef_data %>% 
  group_by(Reef.Name) %>%
  summarise(total_average_bleaching = sum(Average_bleaching))

reef_highest_bleaching <- bleaching_by_reef %>% 
  filter(total_average_bleaching == max(total_average_bleaching)) %>% 
  pull(Reef.Name) 

#Variable 6: Average Bleaching in the highest reef
highest_reef_average_bleaching <- bleaching_by_reef %>% 
  filter(total_average_bleaching == max(total_average_bleaching)) %>% 
  pull(total_average_bleaching)

#Variable 7: Ocean with lowest average bleaching 
ocean_lowest_bleaching <- bleaching_by_ocean %>% 
  filter(total_average_bleaching == min(total_average_bleaching)) %>% 
  pull(Ocean)

#Variable 8: Average bleaching in the lowest ocean
lowest_ocean_average_bleaching <- bleaching_by_ocean %>% 
  filter(total_average_bleaching == min(total_average_bleaching)) %>% 
  pull(total_average_bleaching)

formatted_lowest_ocean_average_bleaching <- format(lowest_ocean_average_bleaching, scientific = FALSE)

#Variable 9: Year with least average bleaching

lowest_bleaching_year <- bleaching_by_year %>% 
  filter(total_average_bleaching == min(total_average_bleaching)) %>% 
  pull(Year)

lowest_bleaching_year_1 <- lowest_bleaching_year[1]
lowest_bleaching_year_2 <- lowest_bleaching_year[2]

#Variable 10: Average bleaching in the lowest year
lowest_year_average_bleaching <- bleaching_by_year %>% 
  filter(total_average_bleaching == min(total_average_bleaching)) %>% 
  pull(total_average_bleaching)

lowest_year_average_bleaching <- lowest_year_average_bleaching[1]


my_server <- function(input, output, session) {
  
  output$bleaching_map <- renderLeaflet({
    selected_intervals_data <- reef_data %>%
      filter(interval %in%  input$user_interval)
    map <- leaflet() %>%
      setView(lng = 0, lat = 0, zoom = 2)
    map <- map %>%
      addProviderTiles("OpenStreetMap.Mapnik")
    map <- map %>%
      addCircleMarkers(
        data = selected_intervals_data,
        lng = ~Longitude,
        lat = ~Latitude,
        color = "red",
        radius = 2,
        opacity = 0.5,
        fillOpacity = 0.5
      )
    map
  })
  
  output$bleaching_oceans <- renderPlotly({
    selected_oceans_years <- coral_reef_data %>%
      filter(Ocean %in% input$ocean) %>%
      filter(Year >= input$years[1], Year <= input$years[2])
    
    reef_by_ocean <- ggplot(selected_oceans_years, aes(x = Year, y = bleaching, color = Ocean)) + 
      geom_line() +
      labs(x = "Year",
           y = "Bleaching")
    
    ggplotly(reef_by_ocean)
  })
  
  output$bleaching_factors <- renderPlotly({
    selected_causes_data <- causes_data %>%
      group_by(Year, !!sym(input$factor), .groups = "drop") %>%
      summarize(count = n(), .groups = "drop") %>%
      ungroup()
    
    reshaped_data <- selected_causes_data %>%
      pivot_wider(names_from = !!sym(input$factor), values_from = count) %>%
      replace(is.na(.), 0)
    
    bar_chart <- ggplot(reshaped_data, aes(x = Year, y = !!sym(input$level), fill = !!sym(input$level))) +
      geom_col(position = "stack") +
      labs(x = "Year",
           y = "Number of Corals Impacted"
      ) +
      scale_fill_continuous(name = "Number of Corals Impacted")
    
    ggplotly(bar_chart)
  })
  
  output$question <- renderUI({
    ques <- list(
      tags$h3("Research Questions"),
      tags$p("We initially sought to answer the following questions:"),
      tags$p("1. What is the global extent of coral reef bleaching?"),
      tags$p("2. How do different oceans vary in terms of coral reef bleaching?"),
      tags$p("3. What are the main factors causing coral reef bleaching?"),
      tags$p("4. How has the severity of coral reef bleaching changed over time?")
    )
    
    specific_takeaway <- list(
      tags$h3("Four specific takeaways based on our observations and visualizations"),
      tags$h4("Takeaway 1"),
      tags$p("We found that the year with the highest rates of coral reef bleaching was 2005, with an average of 3206.325 reef colony bleaching events. The years with the lowest rates of coral reef bleaching were 2000 and 2001, both having 5 average reef colony bleaching events."),
      tags$p("The conclusion drawn from our initial visualization suggests that coral bleaching is not evenly distributed worldwide. However, this conclusion is based on a limited analysis of ocean data, and our understanding of coral bleaching in other oceans is currently limited due to a lack of comprehensive information."),
      tags$h4("Takeaway 2"),
      tags$p("In this study, we analyzed a total of six oceans: Indian, Pacific, Arabian Gulf, Atlantic, Red Sea, and East Pacific."),
      tags$p("We found that the Pacific Ocean had the highest average bleaching rates from 1998 to 2017, with an average of 11,487.36 reef colonies recorded as bleached. The coral reef with the highest average bleaching from 1998 to 2017 was the Mango Bay Reef, located in Koh Tao, Thailand, in the Pacific Ocean, with an average bleaching of 611."),
      tags$p("The Atlantic Ocean experienced the most severe coral bleaching between 2004 and 2005, with a sharp increase of 2417.25 coral bleaching events."),
      tags$h4("Takeaway 3"),
      tags$p("Through our third visualization, we discovered that Human Impact is the factor that has the greatest impact on coral bleaching. Further analysis revealed that the proportion of low human impact is the highest. This suggests that while there are few individuals who cause significant impact on coral bleaching, the cumulative effect of the unaware actions of ordinary people contributes to the irreversible impact on coral bleaching."),
      tags$h4("Takeaway 4"),
      tags$p("Over time, we observed the peak periods of coral bleaching in different oceans:"),
      tags$p("The coral bleaching in the Arabian Gulf, Red Sea, and East Pacific showed relatively minor variations, with consistently lower bleaching levels compared to other oceans."),
      tags$p("The Pacific Ocean exhibited an overall increasing trend in coral bleaching from 1998 to 2017. The bleaching rate peaked in 2016 and gradually declined thereafter."),
      tags$p("The Indian Ocean showed an overall declining trend in coral bleaching from 1998 to 2017. The bleaching rate peaked in 2003 and gradually returned to near-zero levels from 2004 to 2017, with minimal fluctuations."),
      tags$p("Similarly, the Atlantic Ocean demonstrated an overall declining trend in coral bleaching from 1998 to 2017. The bleaching rate peaked in 2005 and consistently decreased in subsequent years.")
    )
    
    insight <- list(
      tags$h3("Most important insight"),
      tags$p("As mentioned earlier, the biggest factor contributing to coral bleaching is human impact. However, coral bleaching also has significant negative impacts on human daily life:"),
      tags$ul(
        tags$li("Loss of Biodiversity: Coral reefs are home to a vast array of marine species, making them one of the most diverse ecosystems on the planet. When corals bleach and die, it disrupts the delicate balance of the reef ecosystem, leading to the loss of biodiversity. This not only affects the coral species but also impacts the countless organisms that depend on coral reefs for food, shelter, and breeding grounds."),
        tags$li("Economic Impact: Coral reefs provide numerous economic benefits to coastal communities and countries. They support fisheries, tourism, and recreational activities, generating revenue and employment opportunities. Coral bleaching can devastate these industries by reducing fish populations, diminishing tourism attractiveness, and damaging coastal protection provided by healthy reefs."),
        tags$li("Ecosystem Services: Coral reefs provide essential ecosystem services, such as shoreline protection, water filtration, and carbon sequestration. Healthy reefs act as natural barriers, reducing the impact of storms and protecting coastal areas from erosion. Bleached and degraded reefs are less effective in providing these crucial services, leaving coastal communities more vulnerable to natural disasters and erosion."),
        tags$li("Climate Change Indicator: Coral bleaching is closely linked to climate change. Rising sea temperatures, ocean acidification, and other climate-related factors stress corals, leading to bleaching events. The occurrence of widespread and severe bleaching events serves as an indicator of environmental changes and the impacts of global warming on marine ecosystems. Protecting coral reefs is crucial in addressing the broader issue of climate change."),
        tags$li("Loss of Medicinal Resources: Coral reefs are a rich source of natural compounds with potential medicinal properties. Many pharmaceutical products and treatments have been derived from marine organisms found in coral reef ecosystems. With the decline of coral reefs, there is a loss of potential discoveries and advancements in medical research.")
      ),
      tags$p("Addressing coral bleaching is not only crucial for the conservation of coral reefs themselves but also for the well-being of coastal communities, marine ecosystems, and global sustainability efforts. It requires collective action, including reducing greenhouse gas emissions, protecting marine habitats, and promoting sustainable practices in coastal areas.")
    )
    
    do.call(tagList, c(ques, specific_takeaway, insight))
  })
  
  output$variable <- renderUI({
    tagList(
      HTML('<pre style="font-size: 10px;">Variable name                      <strong>Variable value</strong></pre>'),
      HTML(paste('<pre style="font-size: 10px;">year_highest_bleaching            <strong>', highest_bleaching_year, '</strong></pre>')),
      HTML(paste('<pre style="font-size: 10px;">highest_year_average_bleaching    <strong>', highest_year_average_bleaching,'</strong></pre>')),
      HTML(paste('<pre style="font-size: 10px;">ocean_highest_bleaching           <strong>',ocean_highest_bleaching,'</strong></pre>')),
      HTML(paste('<pre style="font-size: 10px;">highest_ocean_average_bleaching   <strong>',formatted_highest_ocean_average_bleaching,'</strong></pre>')),
      HTML(paste('<pre style="font-size: 10px;">reef_highest_bleaching            <strong>', reef_highest_bleaching,'</strong></pre>')),
      HTML(paste('<pre style="font-size: 10px;">ocean_lowest_bleaching            <strong>',ocean_lowest_bleaching,'</strong></pre>')),
      HTML(paste('<pre style="font-size: 10px;">lowest_ocean_average_bleaching    <strong>', formatted_lowest_ocean_average_bleaching,'</strong></pre>')),
      HTML(paste('<pre style="font-size: 10px;">lowest_bleaching_year             <strong>', lowest_bleaching_year_1,'</strong></pre>')),
      HTML(paste('<pre style="font-size: 10px;">lowest_year_average_bleaching     <strong>',lowest_year_average_bleaching,'</strong></pre>'))
    )
  })
  
  
  
  
  
  
  
  
}


  
  
  