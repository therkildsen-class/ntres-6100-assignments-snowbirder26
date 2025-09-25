# Hannah Pryor
# In-class practice
# September 2025

# Setup ------------------------------------------------------------------------

library(tidyverse)
library(skimr)

View(coronavirus)




# TUESDAY 9/16 IN-CLASS PRACTICE -----------------------------------------------

# filter by US
coronavirus_us <- filter(coronavirus, country == "US")

# 3 European countries, deaths on Sept 16 2021
filter(coronavirus, country %in% c("Denmark", "Italy", "Spain"), type == "death", 
date == "2021-09-16")

# see cases per country
View(count(coronavirus, country))

# other stuff from 9/16 class that I missed because my laptop wouldn't turn on
select(coronavirus, type, cases, date, country)
select(coronavirus, -province)

select (coronavirus, country, lat, long)
select(coronavirus, date:cases)
select (coronavirus, contains('y'), everything())




# THURSDAY 9/18 IN-CLASS PRACTICE ----------------------------------------------

# create coronavirus_us_2 variable
coronavirus_us_2 <- select(coronavirus_us, -lat, -long, -province)

# pipe operator -> use this one |>
# SHIFT -> CTRL -> M is the keyboard shortcut

# line breaks not necessary for function, but new lines/indents look cleaner
coronavirus |> 
  filter(country == "US") |> 
  select( -lat, -long, -province)

# subset to only include death counts in US, Canada, or Mexico
# remember that %in% is the "included in" operator
# variable names do not need quotation marks
coronavirus |> 
  filter(country %in% c("US", "Canada", "Mexico"), type == "death") |> 
  select(country, date, cases)


# pipe into ggplot
coronavirus |> 
  filter(country %in% c("US", "Canada", "Mexico"), type == "death") |> 
  select(country, date, cases) |> 
  ggplot() +
  geom_line(mapping = aes(x=date, y=cases, color = country))



# vaccine data and mutate function

# load and view new data
vacc <- read.csv("https://raw.githubusercontent.com/RamiKrispin/coronavirus/main/csv/covid19_vaccine.csv")
View(vacc)

#base R
max(vacc$date)

# subsetting data and creating a new variable vaxxrate
# the round function with the 2 included rounds to 2 decimals
vacc |> 
  filter(date == max(date)) |> 
  select(country_region, continent_name, people_at_least_one_dose, population) |> 
  mutate (vaxxrate = round(people_at_least_one_dose / population, 2))

# create a variable that shows average doses distributed per fully vaccinated 
# person in each country -> first, look at patterns across all countries and
# then only show data for countries w/ more than 200 million doses
vacc |> 
  filter(date == max(date)) |> 
  select(country_region, continent_name, doses_admin, people_at_least_one_dose, population) |> 
  mutate(doses_per_vaxxed = doses_admin / people_at_least_one_dose) |> 
  filter(doses_admin > 200*10^6) #could also be in the first filter ()

# show why we would need another filter()
vacc |> 
  filter(date == max(date)) |> 
  select(country_region, continent_name, doses_admin, people_at_least_one_dose, population) |> 
  mutate(doses_per_vaxxed = doses_admin / people_at_least_one_dose) |> 
  filter(doses_per_vaxxed > 3) |> # need the second filter for the new variable
  arrange(-doses_per_vaxxed) # arrange by doses per vaxxed

# In how many countries does >90% of the population have one dose, and
# which 5 countries have the highest vaccination rates
vacc |> 
  filter(date == max(date)) |> 
  select(country_region, continent_name, doses_admin, people_at_least_one_dose, population) |> 
  mutate(percent_vaxxed = (people_at_least_one_dose / population)*100) |> 
  filter(percent_vaxxed >90) |>  # why are some of these over 100%? Data issues?
  arrange(-percent_vaxxed) |> 
  head(5)

# TUESDAY 9/23 IN-CLASS PRACTICE -----------------------------------------------

# Summarizing

coronavirus |> 
  filter (type == "confirmed") |> 
  group_by(country) |> 
  summarize (total = sum(cases),
             n=n()) |>  #observation count
  arrange(-total)

# review the lecture because working on genetics in class

coronavirus |> 
  filter(type=="death") |> 
  group_by(date) |> 
  summarize(total=sum(cases)) |> 
  arrange(-total)

ggbase <- 
  coronavirus |> 
  filter(type=="confirmed") |> 
  group_by(date) |> 
  summarize(total_cases=sum(cases)) |> 
  ggplot(mapping = aes(x=date, y=total_cases)) +
  geom_line()

# now you saved the code above into the ggbase variable and can start with it!
ggbase +
  geom_line()

# can adjust lines with col= and fill with fill=
# do this inside geom feature
# linetype= (Google line types, ex. dashed)

# shape, size, alpha (transparency adjustment)

ggbase +
  geom_point(mapping=aes(size=total_cases, color=total_cases), # redundant
             alpha=0.4) +
  theme_minimal() +
  theme(legend.position="none")+
  labs(
    x="Date",
    y="Total Confirmed Cases",
    title = str_c("Daily counts of new coronavirus cases ", max(coronavirus$date)),
    subtitle = "Global sums"
  )

# create top_5_countries variable
top_5_countries <- coronavirus |> 
  filter(type == "confirmed") |> 
  group_by(country) |> 
  summarize(total=sum(cases)) |> 
  arrange(-total) |> 
  head(5) |> 
  pull(country)
  
# create side-by-side graphs
coronavirus |> 
  filter(type == "confirmed", country %in% top_5_countries) |> 
  group_by(date, country) |> 
  summarize(total=sum(cases)) |> 
  ggplot() +
  geom_line(mapping = aes(x=date, y=total, color=country)) +
  facet_wrap(~country)
  
  
  
# TURSDAY 9/25 IN-CLASS PRACTICE -----------------------------------------------

