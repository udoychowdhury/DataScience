# Load required libraries
library(tidyverse)   # Load the tidyverse package for data manipulation and visualization
library(lubridate)   # Load the lubridate package for working with dates and times

# Read the data from the file
# Skip the first 28 rows to start reading the data from line 29
df <- read.csv("Little_Egg_Inlet_20160922_181616.csv", skip = 28, header = TRUE, check.names = FALSE)

# ----- Renaming columns to remove parentheses -----
# Remove all characters within parentheses
colnames(df) <- gsub("\\(.*\\)", "", colnames(df)) 

# Remove leading/trailing white spaces
colnames(df) <- trimws(colnames(df))

# Replace white spaces with underscores
colnames(df) <- gsub("\\s+", "_", colnames(df))

# ------ Adding new columns -----
# Convert temperature from Celsius to Fahrenheit
df$`Temperature_Fahrenheit` <- (df$`Temperature` * 9/5) + 32

# Add datetime for the readings
df$Datetime <- mdy_hm("9/22/2016 14:16")

# Add Day of the Week Column 
df$Day_of_Week <- wday(df$Datetime, label = TRUE) 

# ----- Analysis ------
# Identify numeric columns
numeric_cols <- sapply(df, is.numeric)

# Calculate averages for numeric columns
averages <- sapply(df[, numeric_cols], mean, na.rm = TRUE)

# Calculate standard deviations for numeric columns
sds <- sapply(df[, numeric_cols], sd, na.rm = TRUE)  

# Calculate Correlation between Temperature and other numeric columns
# Complete.obs makes sure it only uses complete columns
cor_values <- sapply(df[, numeric_cols], function(col) cor(df$Temperature, col, use = "complete.obs"))

# ----- Display Dataframes -----
# Displaying the updated dataframe
print(df)

# Displaying the averages and standard deviations
print(averages)
print(sds)

# Displaying correlations
print(cor_values)
