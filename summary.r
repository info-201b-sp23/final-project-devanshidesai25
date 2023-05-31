#load packages
library("dplyr")

#Load Dataset
coral_reef_data <- read.csv( "/Users/yijunye/Desktop/UW/INFO201/final-project-devanshidesai25/raw_reef_check_data.csv")
coral_bleaching_data <- read.csv("/Users/yijunye/Desktop/UW/INFO201/final-project-devanshidesai25/NOAA_Reef_Check__Bleaching_Data.csv")
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

#Variable 11 : Average extent behavior in human impact
extent_human_impact <- coral_bleaching_data %>% 
  group_by(HumanImpact) %>% 
  summarize(num_cases = n())

top_extent <- extent_human_impact %>% 
  top_n(1)


#Saving Summary into a list
summary_info <- list()
summary_info$year_highest_bleaching <- highest_bleaching_year
summary_info$average_bleaching_in_highest_year <- highest_year_average_bleaching
summary_info$year_lowest_bleaching_1 <- lowest_bleaching_year_1
summary_info$year_lowest_bleaching_2 <- lowest_bleaching_year_2
summary_info$average_bleaching_in_lowest_year <- lowest_year_average_bleaching
summary_info$ocean_highest_bleaching <- ocean_highest_bleaching
summary_info$average_bleaching_in_highest_ocean <- formatted_highest_ocean_average_bleaching
summary_info$ocean_lowest_bleaching <- ocean_lowest_bleaching
summary_info$average_bleaching_in_lowest_ocean <- formatted_lowest_ocean_average_bleaching
summary_info$reef_highest_bleaching <- reef_highest_bleaching
summary_info$average_bleaching_in_highest_reef <- highest_reef_average_bleaching


