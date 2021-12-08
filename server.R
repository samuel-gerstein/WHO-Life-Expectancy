#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source("global.R")
library(shiny)
library(tidyverse)
data <-
  read.csv(
    "https://raw.githubusercontent.com/samuel-gerstein/WHO-Life-Expectancy/main/Life%20Expectancy%20Data.csv",
    header = TRUE
  )
colnames(data)[which(names(data) == "Life.expectancy")] <-
  "Life Expectancy"
colnames(data)[which(names(data) == "Status")] <- "Development"
# Define server logic required to draw a histogram
country_name <- data$Country

server <- function(input, output, session) {
  ## Tab 1
  updateSelectizeInput(session,
                       "country_bar",
                       choices = country_name,
                       server = TRUE)
  country_data <- reactive({
    if (!is.null(input$country_bar) & !is.null(input$year_bar))
    {
      return(
        subset(
          data,
          country_name %in% input$country_bar &
            data$Year %in% input$year_bar
        )
      )
    }
    else if (!is.null(input$country_bar))
    {
      return(subset(data, country_name %in% input$country_bar))
    }
    else
    {
      return(subset(data, data$Year %in% input$year_bar))
    }
  })
  output$CountryTable <- renderTable(country_data())
  
  choice_data <- reactive({
    if (input$group_bar == "Year" & input$statistic_bar == "Mean")
    {
      return(data %>%
               group_by(Year) %>%
               select(-c("Development", "Country")) %>%
               summarize_all(mean, na.rm = TRUE))
    }
    
    else if (input$group_bar == "Year" &
             input$statistic_bar == "Median")
    {
      return(data %>%
               group_by(Year) %>%
               select(-c("Development", "Country")) %>%
               summarize_all(median, na.rm = TRUE))
    }
    else if (input$group_bar == "Year" &
             input$statistic_bar == "Standard Deviation")
    {
      return(data %>%
               group_by(Year) %>%
               select(-c("Development", "Country")) %>%
               summarize_all(sd, na.rm = TRUE))
    }
    if (input$group_bar == "Country" &
        input$statistic_bar == "Mean")
    {
      return(data %>%
               group_by(Country) %>%
               select(-c("Development", "Year")) %>%
               summarize_all(mean, na.rm = TRUE))
    }
    if (input$group_bar == "Country" &
        input$statistic_bar == "Median")
    {
      return(
        data %>%
          group_by(Country) %>%
          select(-c("Development", "Year")) %>%
          summarize_all(median, na.rm = TRUE)
      )
    }
    if (input$group_bar == "Country" &
        input$statistic_bar == "Standard Deviation")
    {
      return(data %>%
               group_by(Country) %>%
               select(-c("Development", "Year")) %>%
               summarize_all(sd, na.rm = TRUE))
    }
    if (input$group_bar == "Development" &
        input$statistic_bar == "Mean")
    {
      return(
        data %>%
          group_by(Development) %>%
          select(-c("Country", "Year")) %>%
          summarize_all(mean, na.rm = TRUE)
      )
    }
    if (input$group_bar == "Development" &
        input$statistic_bar == "Median")
    {
      return(
        data %>%
          group_by(Development) %>%
          select(-c("Country", "Year")) %>%
          summarize_all(median, na.rm = TRUE)
      )
    }
    if (input$group_bar == "Development" &
        input$statistic_bar == "Standard Deviation")
    {
      return(
        data %>%
          group_by(Development) %>%
          select(-c("Country", "Year")) %>%
          summarize_all(sd, na.rm = TRUE)
      )
    }
  })
  
  output$StatsTable <- renderTable(choice_data())
  
  
  
  
  ## Tab 2
  observe({
    if (input$x_bar == "Life Expectancy")
    {
      updateSelectizeInput(
        session,
        "y_bar",
        choices = c("BMI", "Development"),
        server = TRUE
      )
      observe({
        if (input$y_bar == "BMI")
        {
          updateCheckboxGroupInput(session, "z_bar", choices = c("Development"))
        }
        else {
          updateCheckboxGroupInput(session, "z_bar", choices = c("BMI"))
        }
      })
    }
  })
  observe({
    if (input$x_bar == "BMI")
    {
      updateSelectizeInput(
        session,
        "y_bar",
        choices = c("Life Expectancy", "Development"),
        server = TRUE
      )
      observe({
        if (input$y_bar == "Life Expectancy")
        {
          updateCheckboxGroupInput(session, "z_bar", choices = c("Development"))
        }
        else {
          updateCheckboxGroupInput(session, "z_bar", choices = c("Life Expectancy"))
        }
      })
    }
  })
  observe({
    if (input$x_bar == "Development")
    {
      updateSelectizeInput(
        session,
        "y_bar",
        choices = c("BMI", "Life Expectancy"),
        server = TRUE
      )
      observe({
        if (input$y_bar == "BMI")
        {
          updateCheckboxGroupInput(session, "z_bar", choices = c("Life Expectancy"))
        }
        else {
          updateCheckboxGroupInput(session, "z_bar", choices = c("BMI"))
        }
      })
    }
  })
  
  observe({
    if ((input$x_bar == "Development") | (input$y_bar) == "Development")
    {
      removeUI(selector = "#smoothed_option")
    }
    else
    {
      
    }
  })
  output$visualization <- renderPlot({
    if ((input$x_bar != "Development") & (input$y_bar != "Development"))
    {
      if (is.null(input$z_bar))
      {
        scatter <-
          ggplot(data, aes(x = .data[[input$x_bar]], y = .data[[input$y_bar]])) +
          geom_point() +
          labs(title = paste(input$x_bar, "vs.", input$y_bar))
        if (input$smoothed_option == TRUE)
        {
          scatter <- scatter + geom_smooth()
        }
        print(scatter)
      }
      else
      {
        scatter <-
          ggplot(data, aes(x = .data[[input$x_bar]], y = .data[[input$y_bar]])) +
          geom_point(aes(color = .data[[input$z_bar]])) +
          labs(title = paste(input$x_bar, "vs.", input$y_bar))
        
        if (input$smoothed_option == TRUE)
        {
          scatter <- scatter + geom_smooth()
        }
        print(scatter)
      }
    }
    else
    {
      if (is.null(input$z_bar))
      {
        boxplot <-
          ggplot(data, aes(x = .data[[input$x_bar]], y = .data[[input$y_bar]])) +
          geom_boxplot() +
          labs(title = paste(input$x_bar, "vs.", input$y_bar))
        print(boxplot)
      }
      else
      {
        boxplot <-
          ggplot(na.omit(data), aes(x = .data[[input$x_bar]], y = .data[[input$y_bar]])) +
          geom_boxplot() +
          facet_wrap(~ cut(.data[[input$z_bar]], 4)) +
          labs(title = paste(
            input$x_bar,
            "vs.",
            input$y_bar,
            "(Faceted By",
            input$z_bar,
            ")"
          ))
        print(boxplot)
      }
    }
  })
  
  
  
  ##Tab 3
  updateSelectizeInput(session,
                       "predictor_bar",
                       choices = colnames(data),
                       server = TRUE)
  observe({
  updateSelectizeInput(session,
                       "response_bar",
                       choices = subset(colnames(data), !(colnames(data) %in% input$predictor_bar)),
                       server = TRUE)
  })
}
