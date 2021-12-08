DynamicInput <- function(input, choice1, bar)
{
  if (input == choice1)
  {
    updateSelectizeInput(session, "y_bar", choices = c("BMI", "Development"), server=TRUE)
    updateSelectizeInput(session, "y_bar", choices = c("BMI", "Development"), server=TRUE)
  }
}