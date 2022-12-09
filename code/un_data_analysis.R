# GETTING STARTED ---- 

# Previously learned ggplot2 package, but what if we want to:
# 1. work on a subset of data
# 2. clean up messy data
# 3. calculate summary statistics
# 4. create a new variable
# 5. join two data sets together

# We will use deplyr 

# . Loading in new data ----
# .. Exercise: loading the data ----

# first need to load in appropriate libraries
library(tidyverse)
# then can load in data
gapminder_data <- read_csv("data/gapminder_data.csv")

# INTRO TO DATA ANALYSIS IN R USING DPLYR ----

# To get mean life expectancy: 
summarize(gapminder_data, average_life_exp = mean(lifeExp))

# Alternatively:
gapminder_data %>% 
  summarize(average_life_exp = mean(lifeExp))

# Can save data frame by assigning to a variable: 
gapminder_data_summarized <- gapminder_data %>% 
  summarize(average_life_exp = mean(lifeExp)) 

# . Narrow down rows with filter() ----

# Summarize found mean life expectancy to be 59.5, which is unusually low.
# There are many years and countries, so it may not make sense to 
# average over all of them. 

# .. Exercise: determine most recent year using summarize() ----
gapminder_data %>% 
  summarize(most_recent_year = max(year))

# Found that our most recent year is 2007
# Now we can subset to the most recent year using filter()
gapminder_data %>% 
  filter(year == 2007) %>% 
  summarize(average = mean(lifeExp))

# .. Exercise: average GDP per cap for the earliest year? ----
gapminder_data %>% 
  filter(year == min(year)) %>% 
  summarize(avg = mean(gdpPercap))

# . Grouping rows using group_by() ----

# How do we calculate the average life expectancy for each year?
# Instead of using many filter() statements, we can use group_by()
gapminder_data %>%
  group_by(year) %>%
  summarize(average = mean(lifeExp))
# group_by() expects one or more column names separated by commas.

# Trying to use summarized minyear:
minyear <- gapminder_data %>% 
  summarize(averageLifeExp=min(year))
gapminder_data %>% 
  filter(year == minyear) %>%
  summarize(average=mean(gdpPercap))

# .. Exercise: avg life expectancy by continent ----
gapminder_data %>% 
  group_by(continent) %>% 
  summarize(average=mean(lifeExp))

# . Creating more than one column for summary ouput ----
continent_meta <- gapminder_data %>% 
  group_by(continent) %>% 
  summarize(avg_life_expectancy = mean(lifeExp),
            min_life_expectancy = min(lifeExp))

# . Making new variables with mutate() ----
# .. Exercise: what is the population, in millions, for Afghanistan 
# in 1972?
gapminder_data %>% 
  mutate(gdp = pop + gdpPercap,
         pop_in_millions = pop/10^6) %>% 
  filter(year == 1972, country == "Afghanistan")

# . Subsetting columns using select()
gapminder_data %>% 
  select(pop, year)

# Can also remove columns
gapminder_data %>% 
  select (-continent)

# Can use starts_with() and ends_with()
gapminder_data %>%
  select(year, starts_with("c"))

gapminder_data %>%
  select(ends_with("p"))

#CHANGING SHAPE OF DATA USING TIDYR ----

# Data comes in many forms
# "Wide" or "long"
# long = one row per observation
# gapfinder is in long format
# long = "tidy" --> easy for ggplot, etc

# Create untidy data with years and life expectancy
gapminder_data %>% 
  select(country, continent, year, lifeExp) %>% 
  pivot_wider(names_from = year, values_from = lifeExp)

# . Prepare Americas 2007 gapminder data set
gapminder_data_2007 <- read_csv("data/gapminder_data.csv") %>% 
  filter(year == 2007, continent == "Americas") %>% 
  select(-year, -continent)
