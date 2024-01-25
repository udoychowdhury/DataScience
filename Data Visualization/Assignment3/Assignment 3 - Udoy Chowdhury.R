# Libraries
library(shiny) # Allows to build a web app.
library(shinydashboard) # Makes dashboard look nice
library(readr) # Reads files
library(plotly) # Make chart interactive
library(shinyWidgets) # Allows for widgets
library(dplyr) # Filter and sort data

# Read in data
stock_tbl1 <- read_csv("stocks_monthly.csv")
stock_tbl2 <- read_csv("xlk_stock_monthly.csv")
stock_tbl <- rbind(stock_tbl1, stock_tbl2)

# Convert date to Date type
stock_tbl$date <- as.Date(stock_tbl$date, format = "%m/%d/%y")

# Build app display
ui <- dashboardPage(
  # App Title
  dashboardHeader(title = "Stock Returns Dashboard"), 
  dashboardSidebar(
    # Add space in the sidebar
    br(), 
    br(), 
    br(), 
    selectInput(
      # Choose which stock symbol
      inputId = "select_symbol", 
      label = "Select Stock Symbol", 
      # Choose the column to put in this input
      choices = c("All", unique(stock_tbl$symbol)),
      # First show all symbols
      selected = "All", 
      # Allow to pick multiple symbols
      multiple = TRUE 
    ),
    # Add space in the sidebar
    br(), 
    br(), 
    br(), 
    dateRangeInput(
      # Choose time frame for the graph
      inputId = "date_range", 
      label = "Date Range", 
      # Earliest Date
      start = min(stock_tbl$date), 
      # Latest Date
      end = max(stock_tbl$date)
    ),
    # Add space in the sidebar
    br(), 
    br(), 
    br(), 
    # Reset Filters Button
    actionButton("reset_button", "Reset Filters") 
  ),
  dashboardBody(
    fluidRow(
      # First Chart
      plotlyOutput("plotly_returns"),
      # Second Chart
      plotlyOutput("plotly_cumulative") 
    )
  )
)

# Define server
server <- function(input, output, session) {
  
  filtered_data <- reactive({
    # Processes what data to show based on what user picked
    if ("All" %in% input$select_symbol) {
      # If "All", shows all symbols
      subset(stock_tbl, date >= input$date_range[1] & date <= input$date_range[2])
    } else {
      # Otherwise, show only selected symbols
      subset(stock_tbl, symbol %in% input$select_symbol & date >= input$date_range[1] & date <= input$date_range[2])
    }
  })
  
  # First Chart
  output$plotly_returns <- renderPlotly({
    # This will show how much money could have made or lost with the stocks through a selected timeframe
    
    # Get the users input
    df <- filtered_data() 
    
    # Create a line chart
    p <- plot_ly(data = df, x = ~date, y = ~monthly.returns, type = "scatter", mode = "lines+markers", color = ~symbol)
    
    # Add titles and labels
    layout(p, title = "Monthly Returns Over Time", xaxis = list(title = "Date"), yaxis = list(title = "Monthly Returns", tickformat = ".3f"))
  })
  
  # Second Chart
  output$plotly_cumulative <- renderPlotly({
    # This will show how much money would have been made if returns were added up
    
    # Get the users input
    df <- filtered_data() 
    
    # Organize by date
    df <- df[order(df$date), ] 
    # Organize by Stock Symbol
    df <- df[with(df, order(symbol)), ]
    
    # Calculate the cumulative returns for each stock.
    df$cumulative_returns <- ave(df$monthly.returns, df$symbol, FUN = cumsum)
    
    # Create a line chart with cumulative data.
    p <- plot_ly(data = df, x = ~date, y = ~cumulative_returns, type = "scatter", mode = "lines+markers", color = ~symbol)
    
    # Add titles and labels
    layout(p, title = "Cumulative Returns Over Time", xaxis = list(title = "Date"), yaxis = list(title = "Cumulative Returns", tickformat = ".3f"))
  })
  
  observeEvent(input$reset_button, {
    # Resets user choices when they press the reset button
    updateSelectInput(session, "select_symbol", selected = "All")
    updateDateRangeInput(session, "date_range", start = min(stock_tbl$date), end = max(stock_tbl$date))
  })
}

# Create Shiny app
shinyApp(ui, server)