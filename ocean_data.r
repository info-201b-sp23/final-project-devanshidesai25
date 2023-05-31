library(dplyr)
library(ggplot2)
library(plotly)

coral_reef_data <- read.csv("raw_reef_check_data.csv")

ocean_data <- coral_reef_data %>%
  group_by(Year, Ocean) %>%
  summarise(bleaching = sum(Average_bleaching), .groups = 'drop') %>%
  filter(Ocean!="")




