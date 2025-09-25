
# Hannah Pryor
# 25 Sept 2025

# load packages
library(tidyverse)


# INTRO TO TIDY DATA NOTES -----------------------------------------------------

# ..............................................................................

# Three rules that make a dataset tidy:
#   each variable forms a column
#   each observation forms a row
#   each cell is a single measurement

# allows use of same tools and makes workflow more reproducible

# ..............................................................................





# PRACTICE USING TIDY DATA PRACTICES -------------------------------------------

# ..............................................................................

# different table types - still running with coronavirus data for now
table1  # this is the only one of these that is in tidy format
table2
table3
table4a
table4b

# ..............................................................................

# we can do things with these tables, too
# it is good to store these modified tables as their own variables
table1 |> 
  mutate(rate=cases/population*10000) # add a column for rate

table1 |> 
  group_by(year) |> 
  summarize(total = sum(cases))

table1 |> 
  ggplot(mapping = aes(x=year, y=cases)) +
  geom_line()

# compute the rate for table2 and table4a and 4b
# much harder to work with because of the data format of the tables
# no one could do this -- point is working with untidy data is difficult

# ..............................................................................

# Common problems:
#  one variable spread across multiple columns
#  one observation spread across multiple rows

# ..............................................................................

# pivot functions that can help us shift untidy data into tidy format

table4a_tidy <- table4a |> 
  pivot_longer(c('1999', '2000'), names_to = "year", values_to = "cases")

table4b_tidy <- table4b |> 
  pivot_longer(c('1999', '2000'), names_to = "year", values_to = "population")

# remember that existing variables do not need quotation marks
table2 |> 
  pivot_wider(names_from = type, values_from = count)

# YOU CAN PRACTICE THESE ON YOUR OWN WITH THE LOTR DATASET

# ..............................................................................

# problem with the rate variable is that it has >1 value per cell
# how do we split these up?  the separate function!

table3 |> 
  separate(rate, into = c("cases", "population")) # quotations for new variables
# knows where to split by first encounter of a non-numerical character
# can also add sep = "/" to tell it where to break the two up
# convert = TRUE makes the observations all integer variables

table5 <- table3 |> 
  separate(year, into = c("century", "year"), sep = 2) 
# sep = 2 tells it to split after 2nd character

table5 |> 
  unite(fullyear, century, year, sep = "")

# ..............................................................................

# Application to coronavirus dataset (still loaded from wrangling.R script)
# This dataset is in tidy format (depending on what we are trying to explore)
View(coronavirus)

# ..............................................................................




