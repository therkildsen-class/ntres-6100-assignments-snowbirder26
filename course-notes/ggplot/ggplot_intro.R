# NTRES 6100 practice
# Hannah Pryor
# 11 Sept 2025



#-------------------------------------------------------------------------------
#SETUP
#-------------------------------------------------------------------------------

# load packages
library(tidyverse)

# load preexisting data set
mpg

# learn about data set
?mpg

# look at different data set (not tibble) for comparison
cars
?cars

# pull up data in spreadsheet-like format
# you can't really use this command in a Quarto document, though
View(mpg)



#-------------------------------------------------------------------------------
# GGPLOT2 INTRO
#-------------------------------------------------------------------------------

# mapping a basic plot with the mpg data
ggplot(data=mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

# try running without geometric object layers added
ggplot(data=mpg)

# try making a scatter plot of hwy vs cyl
ggplot(data=mpg) +
  geom_point(mapping = aes(x = cyl, y = hwy))

# scatter plot with class and drv
ggplot(data=mpg) +
  geom_point(mapping = aes(x = class, y = drv))

# display adjustments
ggplot(data=mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = cyl), color = "blue", 
             shape = 1)

# add a trend line
ggplot(data=mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = cyl), color = "blue", 
             shape = 1) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# move mapping up to ggplot level -- makes it the default for all layers below
ggplot(data=mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, size = cyl), color = "blue", 
              shape = 1) +
  geom_smooth()

# add a facet wrap to split plots by a variable and change theme
ggplot(data=mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, size = cyl), color = "blue", 
              shape = 1) +
  geom_smooth() +
  facet_wrap(~ year, nrow = 2) +
  theme_minimal()




