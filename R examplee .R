
setwd("/Users/Josh/Dropbox/Data Viz")
install.packages(c("tidyverse","Manu", "gameofthrones"))
library(tidyverse) #R has some base functions when you load it, but if you want to do other stuff
#you have to load packages 3-4 installs those packages
library(Manu)
library(gameofthrones)


color1 <- get_pal("Kaka") #sets custom colors to a bird in new zealand
penguins <- read.csv("penguins.csv") %>% 
  na.omit() #gets rid of missing values

#this is how I would make the basic plot from the example
#think of ggplot as tw or gr in Stata
ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point() #geom is how you specify what kind of plot you want

#this also works
#the difference between line 16 and line 21 is essentially trivial
ggplot(data = penguins) +
  geom_point(aes(x = flipper_length_mm, y = body_mass_g))


#like Stata where you put stuff matters. Here is the plot I want
ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g, 
                            color = species, shape = species)) +
  geom_point() +
  labs(x = "Flipper Length(mm", y = "Body Mass(g)") +
  theme_minimal() 


# We wanted the points to be colored by species. However when it is outside of 
# "aes" or aesthics it does not do what we want
# if you want to differentiate stuff by a column in your dataset it should be the
# in the aes 
ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g), 
       color = species, shape = species ) +
  geom_point() +
  labs(x = "Flipper Length(mm", y = "Body Mass(g)") +
  theme_minimal() 

#this is also a common mistake R is looking for a column name

ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g, color = "blue")) +
  geom_point() +
  labs(x = "Flipper Length(mm", y = "Body Mass(g)") +
  theme_minimal() 



#if you just want to change the color of the dots here is what you would do 
ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(color = "blue") +
  theme_minimal() 

#or this

ggplot(data = penguins) +
  geom_point(aes(x = flipper_length_mm, y = body_mass_g),color = "blue") +
  labs(x = "Flipper Length(mm", y = "Body Mass(g)") +
  theme_minimal()


#this is how you jitter stuff in R. You can alao do geom_quasiransom
ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point() +
  geom_jitter() +
  theme_minimal()

ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g, 
                            color = species , line = species)) +
  geom_point() +
  geom_jitter() +
  geom_smooth(method = lm, se = FALSE) +
  labs(x = "Flipper Length(mm)", y = "Body Mass(g)") +
  theme_minimal() 

ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g, 
                            color = species , line = species, shape  = species)) +
  geom_point() +
  geom_jitter() +
  geom_smooth(method = lm, se = FALSE) +
  labs(x = "Flipper Length(mm)", y = "Body Mass(g)") +
  theme_minimal() +
  scale_color_manual(values = color1)


ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g, 
                            color = species , line = species, shape  = species)) +
  geom_point() +
  geom_jitter() +
  geom_smooth(method = lm, se = FALSE) +
  labs(x = "Flipper Length(mm)", y = "Body Mass(g)") +
  theme_minimal() + 
  scale_color_manual(values = get_pal("Hoiho"))




penguins %>%
  count(species, island) %>%
  ggplot() + geom_col(aes(x = species, y = n, fill = species)) +
  geom_label(aes(x = species, y = n, label = n)) +
  scale_fill_manual(values = color1) +
  facet_wrap(vars(island)) +
  theme_minimal() +
  labs(title = "Penguins Species & Count", y= "Count", x= "Species")

#you can also animate this plot which Stata will not let you do 
install.packages("plotly")
library(plotly)

library(patchwork)

dynamic_plot <- penguins %>%
  count(species, island) %>%
  ggplot() + geom_col(aes(x = species, y = n, fill = species)) +
  geom_label(aes(x = species, y = n, label = n)) +
  scale_fill_manual(values = color1) +
  facet_wrap(vars(island)) +
  theme_minimal() +
  labs(title = "Penguins Species & Count", y= "Count", x= "Species") 

ggplotly(dynamic_plot)


dynamic_plot2<-ggplot(data = penguins, aes(x = flipper_length_mm, y = body_mass_g, 
                            color = species , line = species, shape  = species)) +
  geom_point() +
  geom_jitter() +
  geom_smooth(method = lm, se = FALSE) +
  labs(x = "Flipper Length(mm)", y = "Body Mass(g)") +
  theme_minimal() +
  scale_color_manual(values = color1)

ggplotly(dynamic_plot2)


ggplot(data = penguins, aes(x = species, y = island)) + 
geom_tile() + 
  scale_fill_manual(values = color1)


