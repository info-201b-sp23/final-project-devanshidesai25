library("dplyr")
library("leaflet")
library("leaflet.extras")
library("RColorBrewer")

#load data sets
coral_reef_data <- read.csv("raw_reef_check_data.csv")
coral_reef_coordinates <-read.csv("reefs_with_coordinates.csv")

#prepare map data
average_bleachings <- coral_reef_data %>%
  group_by(Reef.ID) %>%
  summarise(total_bleachings = sum(Average_bleaching))

new_coral_reef_coordinates <- coral_reef_coordinates %>%
  select(1:10) %>%
  mutate(Longitude.Seconds = gsub("\\.", "", Longitude.Seconds)) %>%
  mutate(Latitude.Seconds = gsub("\\.", "", Latitude.Seconds)) %>%
  mutate(Longitude = if_else(
    Longitude.Cardinal.Direction == "W",
    paste("-", Longitude.Degrees, ".", Longitude.Minutes, Longitude.Seconds, sep = ""),
    paste(Longitude.Degrees, ".", Longitude.Minutes, Longitude.Seconds, sep = "")
  )) %>%
  mutate(Latitude = if_else(
    Latitude.Cardinal.Direction == "S",
    paste("-", Latitude.Degrees, ".", Latitude.Minutes, Latitude.Seconds, sep = ""),
    paste(Latitude.Degrees, ".", Latitude.Minutes, Latitude.Seconds, sep = "")
  )) %>%
  select(1, 2, 11, 12) %>%
  distinct() %>%
  arrange(Reef.Name)

reef_data <- merge(average_bleachings, new_coral_reef_coordinates, by = "Reef.ID")

intervals <- c(0, 10, 20, 50, Inf)
labels <- c("Less than 10", "10-20", "20-50", "50 and above")


reef_data$interval <- cut(
  reef_data$total_bleachings, 
  breaks = intervals, 
  labels = labels, 
  include.lowest = TRUE)

reef_data$Longitude <- as.numeric(reef_data$Longitude)
reef_data$Latitude <- as.numeric(reef_data$Latitude)

