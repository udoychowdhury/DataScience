# ========== Load libraries and Read file==========

library(shiny)       # For making the code into a shiny app
library(shinydashboard)  # For making the code into a shiny app
library(readxl)      # For reading the file
library(ggplot2)     # For graphs
library(shinyWidgets)   # For widgets
library(dplyr)       # For handling data
library(tidyverse)   # For handling data
library(ggiraph)     # Helps create interactive graphics
library(lubridate)   # For dates
library(viridis)     # For color scheme

# Read in data
fpl_data <- read_excel("FPL Data.xlsx")

# ========== Calculate additional columns for analysis and define color scheme ==========

# Doing some math to create new columns based on existing data.
fpl_data$`Form to Cost Today Ratio` <- round(fpl_data$Form / fpl_data$`Cost Today`, 2)
fpl_data$`Selection % to Cost Today Ratio` <- round(fpl_data$`Selection %` / fpl_data$`Cost Today`, 2)
fpl_data$`FD Index to Cost Today Ratio` <- round(fpl_data$`FD Index` / fpl_data$`Cost Today`, 2)

# Combining first name and last name into a column called FullName.
fpl_data$FullName <- paste(fpl_data$Name, fpl_data$Last_Name)

# Define a color for each player position
position_colors <- c("DEF" = "blue", "MID" = "green", "GK" = "orange", "FWD" = "red")


# ========== Build the user interface for the Shiny application ==========

ui <- dashboardPage(
  dashboardHeader(title = "FPL Player Analysis Dashboard"),  # Dashboard title
  dashboardSidebar(
    width = 250,  # Setting the width of sidebar
    br(), br(), br(),  # Adding empty space 
    selectInput(
      inputId = "select_metric",
      label = "Select Y-axis Metric",  # Choose Y Metric
      choices = c("Form to Cost Today Ratio", "Selection % to Cost Today Ratio", "FD Index to Cost Today Ratio"),  # Metric options
      selected = "Form to Cost Today Ratio"  # Default metric
    ),
    br(), br(), br(),  # Adding empty space
    selectInput(
      inputId = "select_position",
      label = "Select Player Position",  # Choose X Metric 
      choices = c("All", unique(fpl_data$Position)),  # Metric Options
      selected = "All",  # Default metric
      multiple = TRUE  # Allow multiple positions
    ),
    br(), br(), br(),  # Adding empty space
    selectInput(
      inputId = "select_order",
      label = "Select Order",  # Choose order of data
      choices = c("Highest to Lowest", "Lowest to Highest", "Alphabetical"),  # Available options
      selected = "Highest to Lowest"  # Default order
    ),
    br(), br(), br(),  # Adding empty space
    actionButton("reset_button", "Reset Filters")  # Reset filters button
  ),
  dashboardBody(
    fluidRow(
      column(width = 12, girafeOutput("plot_player_analysis", width = "100%", height = "700px"))  # Build plot space
    )
  ) 
)

# ========== Define the server logic ==========

server <- function(input, output, session) {
  
  # Create filtered data
  filtered_data <- reactive({
    # Filtered data based on player positions
    data <- if ("All" %in% input$select_position) {
      fpl_data
    } else {
      fpl_data %>% filter(Position %in% input$select_position)
    }
    
    # Remove players with 0 in the selected metric
    data <- data %>% filter(.[[input$select_metric]] != 0)
    
    # Return filtered data
    data
  })
  
  # Render the plot
  output$plot_player_analysis <- renderGirafe({
    df <- filtered_data()  # Get filtered data
    x_metric_name <- input$select_metric  # Get selected metric
    
    # Define hover logic
    df$tooltip <- paste(df[[x_metric_name]], df$FullName, sep = ": ")
    
    # Define x axis order based on user input
    x_order <- if (input$select_order == "Highest to Lowest") {
      reorder(df$FullName, df[[x_metric_name]], FUN = function(x) -max(x))
    } else if (input$select_order == "Lowest to Highest") {
      reorder(df$FullName, df[[x_metric_name]], FUN = max)
    } else {
      df$FullName  # Alphabetical order
    }
    
    # Create bar chart
    plot <- ggplot(df, aes(x = x_order, y = !!sym(x_metric_name), fill = Position, tooltip = tooltip)) +
      geom_bar_interactive(stat = "identity", position = position_dodge()) +  # Adding interactive bars
      scale_fill_manual(values = position_colors) +  # Set bar colors based on position
      labs(title = "Player Analysis", x = "Player", y = input$select_metric) +  # Add chart and axis titles
      theme_minimal() +  # Use minimal theme
      theme(
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        plot.title = element_text(hjust = 0.5, face = "bold"),  # Adjust title
        axis.title.x = element_text(vjust = 6, face = "bold"),  # Adjust x-axis title
        axis.title.y = element_text(face = "bold"),  # Adjusting y-axis title appearance
        axis.text.x = element_blank(),  # Hiding x-axis ticks (player names)
        axis.text.y = element_text(face = "bold")  # Adjusting y-axis text 
      )
    
    girafe(ggobj = plot)  # Make it interactive
  })
  
  # Define "Reset Filters" button
  observeEvent(input$reset_button, {
    updateSelectInput(session, "select_metric", selected = "Form to Cost Today Ratio")
    updateSelectInput(session, "select_position", selected = "All")
    updateSelectInput(session, "select_order", selected = "Highest to Lowest")
  })
}

# Run the Shiny application
shinyApp(ui, server)