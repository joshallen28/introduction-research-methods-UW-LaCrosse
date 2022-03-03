setwd("/Users/Josh/Dropbox/Data Viz")
library(pacman)
p_load("tidyverse",
       "datasauRus",
       "gameofthrones",
       "Manu", "scales", "sf")

color1 = get_pal("Takapu")
color2 = get_pal("Kotare")
color3 = get_pal("Hihi")


dinoplot = ggplot(datasaurus_dozen, aes(x=x, y=y, colour=dataset))+
  geom_point()+
  theme_void() +
  theme(legend.position = "none") +
  facet_wrap(vars(dataset), ncol=3) + 
  scale_color_manual(values = c(color1, color2, color3))

dinoplot


ggsave(filename = "dinoplot.png", plot = dinoplot, width = 6, dpi = 320)


births_1994_1999 <- read_csv("US_births_1994-2003_CDC_NCHS.csv") %>% 
  # Ignore anything after 2000
  filter(year < 2000)

births_2000_2014 <- read_csv("US_births_2000-2014_SSA.csv")

births_combined <- bind_rows(births_1994_1999, births_2000_2014)



month_names <- c("January", "February", "March", "April", "May", "June", "July",
                 "August", "September", "October", "November", "December")

day_names <- c("Monday", "Tuesday", "Wednesday", 
               "Thursday", "Friday", "Saturday", "Sunday")

births <- births_combined %>% 
  # Make month an ordered factor, using the month_name list as labels
  mutate(month = factor(month, labels = month_names, ordered = TRUE)) %>% 
  mutate(day_of_week = factor(day_of_week, labels = day_names, ordered = TRUE),
         date_of_month_categorical = factor(date_of_month)) %>% 
  # Add a column indicating if the day is on a weekend
  mutate(weekend = ifelse(day_of_week %in% c("Saturday", "Sunday"), TRUE, FALSE))

head(births)




ggplot(data = births,
       mapping = aes(x = day_of_week, y = births, color = weekend)) +
  scale_color_manual(values = c("grey70", color1)) +
  geom_point(size = 0.5, position = position_jitter(height = 0)) +
  guides(color = FALSE) + 
  labs(y = "Births", x = "Day of the Week")



avg_births_month_day <- births %>% 
  group_by(month, date_of_month_categorical) %>% 
  summarize(avg_births = mean(births))

 ggplot(data = avg_births_month_day,
       # By default, the y-axis will have December at the top, so use fct_rev() to reverse it
       mapping = aes(x = date_of_month_categorical, y = fct_rev(month), fill = avg_births)) +
  geom_tile() +
  # Add viridis colors
  scale_fill_got(option = "Tully", labels = comma) + 
  # Add nice labels
  labs(x = "Day of the month", y = NULL,
       title = "Average births per day",
       subtitle = "1994-2014",
       fill = "Average births") +
  # Force all the tiles to have equal widths and heights
  coord_equal() +
  # Use a cleaner theme
  theme_minimal()





# https://github.com/jvangeld/ME-GIS
coastline <- read_sf("ME-GIS/Coastline2.shp")
contours <- read_sf("ME-GIS/Contours_18.shp")
rivers <- read_sf("ME-GIS/Rivers.shp")
lakes <- read_sf("ME-GIS/Lakes.shp")
forests <- read_sf("ME-GIS/Forests.shp")
mountains <- read_sf("ME-GIS/Mountains_Anno.shp")
placenames <- read_sf("ME-GIS/Combined_Placenames.shp")

places <- placenames %>% 
  filter(NAME %in% c("Hobbiton", "Rivendell", "Edoras", "Minas Tirith"))

Middle_Earth = ggplot() +
  geom_sf(data = contours, size = 0.15, color = "grey90") +
  geom_sf(data = coastline, size = 0.25, color = "grey50") +
  geom_sf(data = rivers, size = 0.2, color = "#0776e0", alpha = 0.5) +
  geom_sf(data = lakes, size = 0.2, color = "#0776e0", fill = "#0776e0") +
  geom_sf(data = forests, size = 0, fill = "#035711", alpha = 0.5) +
  geom_sf(data = mountains, size = 0.25) +
  geom_sf(data = places) +
  geom_sf_label(data = places, aes(label = NAME), nudge_y = 80000) +
  theme_void() +
  theme(plot.background = element_rect(fill = "#fffce3"))
ggsave(filename = "middleearth.png", plot = Middle_Earth, width = 6, dpi = 320)
