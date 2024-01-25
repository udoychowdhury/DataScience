# Core
library(tidyverse)
library(shiny)
library(shinydashboard)
library(glue)
library(scales)

# Interactive Visualizations
library(plotly)
library(shinyWidgets)

# Read in data
# Assuming the stock data is in an Excel file named 'stocks_monthly.xlsx'
stock_tbl <- read_excel(path = "stocks_monthly.xlsx")

# Convert date to Date type
stock_tbl$date <- as.Date(stock_tbl$date, format = "%m/%d/%y")

# Define UI using dashboardPage
ui <- dashboardPage(
  dashboardHeader(title = "Stock Returns Dashboard"),  # Dashboard title
  dashboardSidebar(  # Sidebar layout
    br(), # Add space
    br(), # Add space
    br(), # Add space
    selectInput(  # Dropdown menu for Stock Symbol
      inputId = "select_symbol",
      label = "Stock Symbol",
      choices = unique(stock_tbl$symbol),
      selected = unique(stock_tbl$symbol),
      multiple = TRUE  # Allow multiple selections
    ),
    dateRangeInput(  # Date range input for selecting date
      inputId = "date_range",
      label = "Date Range",
      start = min(stock_tbl$date),
      end = max(stock_tbl$date)
    ),
    actionButton("reset_button", "Reset Filters")  # Reset button
  ),
  dashboardBody(  # Main content area
    fluidRow(  # Fluid row for plots
      plotlyOutput("plotly_returns"),  # Plot line output for returns
      plotlyOutput("plotly_cumulative")  # Plot line output for cumulative returns
    )
  )
)

# Define server
server <- function(input, output, session) {
  
  # Reactive function to filter data based on user selections
  filtered_data <- reactive({
    stock_tbl %>%
      filter(symbol %in% input$select_symbol,
             date >= input$date_range[1],
             date <= input$date_range[2])
  })
  
  # Create a line plot called plotly_returns for monthly returns
  output$plotly_returns <- renderPlotly({
    filtered_data() %>%  # Reactive function variable now becomes a function 
      plot_ly(x = ~date, 
              y = ~monthly.returns, 
              type = "scatter", 
              mode = "lines+markers",
              color = ~symbol) %>%
      layout(title = "Monthly Returns Over Time", 
             xaxis = list(title = "Date"), 
             yaxis = list(title = "Monthly Returns"))
  })
  
  # Create a line plot called plotly_cumulative for cumulative returns
  output$plotly_cumulative <- renderPlotly({
    filtered_data() %>%
      group_by(symbol) %>%
      arrange(date) %>%
      mutate(cumulative_returns = cumsum(monthly.returns)) %>%
      plot_ly(x = ~date, 
              y = ~cumulative_returns, 
              type = "scatter", 
              mode = "lines+markers",
              color = ~symbol) %>%
      layout(title = "Cumulative Returns Over Time", 
             xaxis = list(title = "Date"), 
             yaxis = list(title = "Cumulative Returns"))
  })
  
  # Observer for reset button click
  observeEvent(input$reset_button, {
    updateSelectInput(
      session,
      "select_symbol",
      selected = unique(stock_tbl$symbol)
    )
    updateDateRangeInput(
      session,
      "date_range",
      start = min(stock_tbl$date),
      end = max(stock_tbl$date)
    )
  })
}

# Create Shiny app
shinyApp(ui, server)
