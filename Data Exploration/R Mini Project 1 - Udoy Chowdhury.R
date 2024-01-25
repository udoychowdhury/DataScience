# ---------------------------------------------- R MINI PROJECT 1 -------------------------------------------------------
# Bring in TidyVerse Library
library(tidyverse)

# Bring in CSV Data regarding Player Statistics of 2022/2023 Regular Season
file = read_delim("2022-2023 Football Player Stats.csv", delim = ";", col_names = TRUE)

# Look at Metadata using glimpse from tidyverse
glimpse(file)

# Get a summary of the dataset
summary(file)

# Display the dimensions of the dataset (rows x columns)
dim(file)

# Display the number of rows in the dataset
nrow(file)

# Display the structure of the dataset
str(file)

# Display the first few rows of the dataset
head(file)

# Display the last few rows of the dataset
tail(file)

# Get a frequency table of a particular column
table(file$Pos)

# Display unique values in a particular column
unique(file$Squad)

# Filter players who played more than 20 matches in a new dataframe
filtered_data <- filter(file, MP > 20)

# Add a new column that calculates goals per 90 minutes in a new dataframe
file_with_gpm <- mutate(file, GoalsPer90 = Goals / `90s`)

# Makes a new dataframe that solely counts the players by position
position_count <- count(file, Pos)

# ------------------------------------------------ Graphs ---------------------------------------------------------
# Bar chart of players by position
  # This plot visualizes the count of players for each position in the dataset.

# Set the data and map the columns to the x and y axes
ggplot(position_count, aes(x = Pos, y = n)) +  
  # Use bars to represent the data
  geom_bar(stat = "identity") +                
  # Add labels to the plot
  labs(title = "Number of Players by Position", x = "Position", y = "Count")  

# Histogram of goals scored by players
  # This plot shows the distribution of goals scored by players in the dataset.

# Set the data and map the Goals column to the x axis
ggplot(file, aes(x = Goals)) +                
  # Use histogram bars with a width of 1 goal
  geom_histogram(binwidth = 1) +              
  # Add labels to the plot
  labs(title = "Distribution of Goals Scored", x = "Goals", y = "Number of Players")  

# Boxplot of goals by position
  # This plot visualizes the distribution of goals scored by players in each position.

# Set the data and map the columns to the x and y axes
ggplot(file, aes(x = Pos, y = Goals)) +       
  # Use a boxplot to represent the data
  geom_boxplot() +                            
  # Add labels to the plot
  labs(title = "Goals Scored by Position", x = "Position", y = "Goals")  

# Scatter plot of Shots vs Goals
  # This plot visualizes the relationship between the number of shots taken and goals scored by players.

# Set the data and map the columns to the x and y axes
ggplot(file, aes(x = Shots, y = Goals)) +     
  # Use points to represent each player
  geom_point() +                              
  # Add labels to the plot
  labs(title = "Relationship between Shots and Goals", x = "Shots", y = "Goals")  