# R Mini Project 4

# Udoy Chowdhury

# Package to read csv
library(readr) 

# Read the data
loan_data <- read_csv("loans.csv")

# Summary statistics for numerical variables
summary(loan_data)

# Check the structure of the dataframe to understand the data types
str(loan_data)

# Count the number of loans for each loan status
table(loan_data$loan_status)

# Calculate the mean annual income of borrowers
mean_annual_inc <- mean(loan_data$annual_inc, na.rm = TRUE)
print(mean_annual_inc)

# Calculate the median loan amount
median_loan_amnt <- median(loan_data$loan_amnt, na.rm = TRUE)
print(median_loan_amnt)

# Calculate average payment made for each loan status
aggregate(loan_data$total_pymnt, by = list(loan_data$loan_status), FUN = mean, na.rm = TRUE)

# Calculate how many borrowers are in each employment length
table(loan_data$emp_length)

# Convert employment length column to numeric values
convert_emp_length <- function(length) {
  if (length == "10+ years") {
    return(10)
  } else if (length == "< 1 year") {
    return(0)
  } else if (length == "n/a") {
    return(NA)
  } else {
    # Remove " years" and " year" from value and convert to numeric
    return(as.numeric(gsub(" years| year", "", length)))
  }
}
# Put conversion function to the employee length column
loan_data$emp_length_numeric <- sapply(loan_data$emp_length, convert_emp_length)
# Check if it worked correctly
print(loan_data$emp_length_numeric)
# Calculate average employment length
mean_emp_length <- mean(loan_data$emp_length_numeric, na.rm = TRUE)
# Print mean employment length
print(mean_emp_length)

# Create bar plot for loan purposes
loan_purpose_count <- table(loan_data$purpose)
# Print the table to see the distribution
print(loan_purpose_count)
# Put the count into a graph
barplot(loan_purpose_count, 
        main = "Distribution of Loans by Purpose", 
        xlab = "Purpose", ylab = "Count of Loans", 
        las = 2, col = "steelblue")

# Create bar plot for average interest rate per grade
  # Calculate average interest rate for each grade
average_int_rate_by_grade <- aggregate(loan_data$int_rate, by = list(loan_data$grade), FUN = mean)
  # Rename columns
colnames(average_int_rate_by_grade) <- c("Grade", "Average Interest Rate")
  # Print averages
print(average_int_rate_by_grade)
  # Put averages in a graph
barplot(average_int_rate_by_grade$`Average Interest Rate`, 
        names.arg = average_int_rate_by_grade$Grade, 
        main = "Average Interest Rate by Loan Grade", 
        xlab = "Grade", ylab = "Average Interest Rate (%)", 
        col = "darkgreen")

# Show relationship between interest rate and loan amount
plot(loan_data$loan_amnt, loan_data$int_rate, main = "Interest Rate vs Loan Amount", xlab = "Loan Amount ($)", ylab = "Interest Rate (%)")

