source("map_data.r")
source("ocean_data.r")
source("causes_data.r")
library("dplyr")
library("plotly")
library("leaflet")
install.packages("tidyr")
library("tidyr")
library("rlang")

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
      labs(title = "Bleaching by Ocean and Year",
           x = "Year",
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
      labs(title = "Important Factors that Affect Coral Reef Bleaching",
           x = "Year",
           y = "Number of Corals Impacted"
      ) +
      scale_fill_continuous(name = "Number of Corals Impacted")
    
    ggplotly(bar_chart)
  })
  
}
  
  
  