##%######################################################%##
#                                                          #
####                  Inspecting data                   ####
#                                                          #
##%######################################################%##

# Clear environment 
rm(list = ls())

# Install packages
# In RStudio use keyboard shortcut ctrl + shift + c to comment/uncomment a line
# install.packages("dplyr")
library(ggplot2)
library(dplyr)


iris$Species

# Find which rows of "Species" column have value "setosa" (returns boolean (TRUE/FALSE))
iris$Species == "setosa"
# Do the same, but subset the data frame
iris[iris$Species == "setosa", ]

# Second way to do the same with subset() function
subset(iris, Species == "setosa")

# Store values in a new object
iris_setosa <- subset(iris, Species == "setosa")
# We can combine what we already learned
iris_setosa_large_sepal <- iris_setosa[iris_setosa$Sepal.Length > 5, ]

# Use tidyverse package to do the same
# Tidyverse is a metapackage (collection of packages) oriented for fast and simple data analysis
# Initially developed by Hadley Wickham -- see https://www.tidyverse.org/

# NOTE - as you will see, R can do many things. One of them is opening weblinks
browseURL("https://www.tidyverse.org/")

## ggplot2

# Map the data
ggplot(iris)

# Add aesthetics for x and y column (many other aesthetics available)
ggplot(iris, aes(x = Species, y = Sepal.Length))

# Add geom (way to plot the data)
ggplot(iris, aes(x = Species, y = Sepal.Length)) + geom_point()
ggplot(iris, aes(x = Species, y = Sepal.Length)) + geom_boxplot()

# Modify aesthetics
ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, color = Species)) + geom_point()
# Some aesthetics only can have one axis
ggplot(iris, aes(x = Petal.Width)) + geom_bar()
ggplot(iris, aes(x = Petal.Width, fill = Species)) + geom_bar()
# Add theme
ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, color = Species)) + 
  geom_point() + 
  theme_minimal()

# Or even fit model to the data
ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, color = Species)) + 
  geom_point() + 
  theme_minimal() +
  geom_smooth(method = "gam")
# Separate the data by facets
ggplot(iris, aes(x = Sepal.Width, y = Sepal.Length, color = Species)) + 
  geom_point() + 
  theme_minimal() +
  geom_smooth(method = "gam") +
  facet_wrap(~ Species)

## dplyr

# select columns
select(iris, Petal.Length)

# Filter rows
filter(iris, Species == "setosa")
filter(iris, Species == "setosa" & Petal.Length < 1.5)

# Sort values
arrange(iris, Petal.Length)
arrange(iris, desc(Petal.Length))

# Group by value
group_by(iris, Species)

# Summarize values
summarize(iris, mean_sepal = mean(Sepal.Length))


# %>% is called pipe operator that uses "piped" variable as first argument.
# head(iris, 3) is the same as iris %>% head(3)
head(iris, 3)

iris %>% 
  head(3)

# Use keyboard shortcut ctrl + shift + m to get the pipe ( %>% )
iris %>% 
  filter(Species == "setosa") %>% 
  filter(Sepal.Length > 5)

# Group by species and calculate mean sepal length
iris %>% 
  group_by(Species) %>% 
  summarize(mean_sepal = mean(Sepal.Length))

# Add more columns
iris %>% 
  group_by(Species) %>% 
  summarize(mean_sepal = mean(Sepal.Length),
            max_sepal = max(Sepal.Length),
            mult_sepal = mean(Sepal.Length) * mean(Sepal.Width))

iris %>% 
  group_by(Species) %>% 
  summarize(mean_sepal = mean(Sepal.Length),
            max_sepal = max(Sepal.Length),
            mult_sepal = mean(Sepal.Length) * mean(Sepal.Width)) 

# Sort values
iris %>% 
  group_by(Species) %>% 
  summarize(mean_sepal = mean(Sepal.Length),
            max_sepal = max(Sepal.Length),
            mult_sepal = mean(Sepal.Length) * mean(Sepal.Width)) %>% 
  arrange(mult_sepal)

# We can also pipe functions such as ggplot

# Sort values
iris %>% 
  group_by(Species) %>% 
  summarize(mean_sepal = mean(Sepal.Length),
            max_sepal = max(Sepal.Length),
            mult_sepal = mean(Sepal.Length) * mean(Sepal.Width)) %>% 
  arrange(mult_sepal) %>% 
  ggplot(aes(x = Species, y = mult_sepal, fill = Species)) + geom_point()
  
