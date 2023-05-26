source("map_data.r")
source("ocean_data.r")
library("dplyr")
library("plotly")
library("leaflet")


my_server <- function(input, output, session) {
  
  output$bleaching_map <- renderLeaflet({
    selected_intervals_data <- reef_data %>%
      filter(interval == input$user_interval)
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
    return(map)
  })
  
  output$bleaching_oceans <- renderPlotly({
    
    selected_oceans_years <- coral_reef_data %>%
      filter(Ocean %in% input$user_selection) %>%
      filter(Year >= input$year_range[1], Year <= input$year_range[2])
    
    reef_by_ocean <- ggplot(coral_reef_data, aes(x = Year, y = bleaching, color = Ocean)) + 
      geom_line() +
      labs(title = "Bleaching by Ocean and Year",
           x = "Year",
           y = "Bleaching")
    
    return(ggplotly(reef_by_ocean))
  })
  
}
  
  
  