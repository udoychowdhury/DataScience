# R Mini Project 3
# Udoy Chowdhury
# The code below helps us visualize various aspects of the honeybee data.

# Load necessary libraries  -----------
library(ggplot2)
library(dplyr)
library(readxl)

# Read in Data  -----------
honeybee_data <- read.csv('/Users/udoychowdhury/Documents/Data Exploration/HoneyBees.csv')

# Look at data structure  -----------
glimpse(honeybee_data)

# Line Graph For Total Honey Production Over The Years For Each State  -----------
ggplot(honeybee_data, aes(x = year, y = totalprod, group = StateName, color = StateName)) +
  geom_line() +
  # Add State Names
  geom_text(aes(label = StateName), check_overlap = TRUE, vjust = -0.5) + 
  # Add Title/Label
  labs(title = "Total Honey Production by Year", x = "Year", y = "Total Production") +
  # Remove Lengend
  theme(legend.position = "none") 
  # Findings
    # North Dakota, California and South Dakota are the top performers over the years while North Dakota have been rising.
    # On the other hand, Califronia went from the top performer in the beggining to dropping drastically to the bottom.

# Histogram Of The Yield Per Colony  -----------
hist(honeybee_data$yieldpercol, main = "Histogram of Yield per Colony", xlab = "Yield per Colony", col = "blue", breaks = 50)
  # Findings
    # Has potential to show trends in honey production over the years in a histogram distribution of yield per colony.
    # Yields between 40 and 60 were the most frequent within this dataset while it is extremely rare to get 140.

# Scatter Plot Of Total Production Vs. Total Neonicotinoid
ggplot(honeybee_data, aes(x = nAllNeonic, y = totalprod)) +
  geom_point() +
  # Add a Linear Regression Line
  geom_smooth(method = lm) +  
  # Add Title/Labels
  labs(title = "Total Production vs Total Neonicotinoid", x = "Total Neonicotinoid", y = "Total Honey Production")
  # Findings
    # Shows any potential relationship between pesticide use and honey production.
    # The more honey production the less petiscide used and the more pesticide used the less honey produced.

# Exploring the relationship between price per lb and year
ggplot(honeybee_data, aes(x = year, y = priceperlb)) +
  geom_line() +
  # Add Title/Labels
  labs(title = "Honey Price Trend Over the Years", x = "Year", y = "Price per lb")
  # Findings
    # Shows how the price of honey has changed over the years.
    # It seems to be only increasing with year 2000 being the lowest and 2012 being the highest.