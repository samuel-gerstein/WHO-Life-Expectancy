#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
navbarPage(
  theme = shinytheme("flatly"),
  "WHO Life Expectancy Analysis",
  tabPanel("Descriptive Statistics",
           tabsetPanel(
             tabPanel(
               "Filter by Country/Year",
               sidebarPanel(
                 selectizeInput(
                   'country_bar',
                   h2("Country"),
                   choices = NULL,
                   multiple = TRUE
                 ),
                 selectInput(
                   'year_bar',
                   h2('Year'),
                   choices = c(2000:2015),
                   selectize = TRUE,
                   multiple = TRUE
                 )
               ),
               style = 'overflow: scroll',
               tableOutput("CountryTable")
             ),
             tabPanel(
               "Summary Statistics by Country, Year, Development",
               sidebarPanel(
                 selectizeInput(
                   'group_bar',
                   h3("Choose Variable to Group By:"),
                   choices = c("Country", "Year", "Development"),
                   multiple = FALSE
                 ),
                 selectizeInput(
                   'statistic_bar',
                   h3("Choose Statistic"),
                   choices = c("Mean", "Median", "Standard Deviation"),
                   multiple = FALSE
                 )
               ),
               
               tableOutput("StatsTable")
             )
           )),
  tabPanel(
    "Visualization",
    sidebarPanel(
      selectizeInput(
        'x_bar',
        h3("Choose x-variable"),
        choices = c("Life_Expectancy", "BMI", "Development"),
        multiple = FALSE
      ),
      
      selectizeInput(
        'y_bar',
        h3("Choose y-variable"),
        choices = NULL,
        multiple = FALSE
      ),
      
      checkboxGroupInput('z_bar', h3("Choose optional variable"), choices =
                           NULL),
      checkboxInput('smoothed_option', h6("Smoothed Line"))
    ),
    plotOutput("visualization")
  ),
  tabPanel(
    "Staistical Analysis",
    sidebarLayout(
      sidebarPanel(
        selectizeInput(
          'predictor_bar',
          h3("Choose Predictor Variables for Linear Regression"),
          choices = NULL,
          multiple = TRUE
        ),
        selectizeInput(
          'response_bar',
          h3("Choose Response Variable for Linear Regression"),
          choices = NULL,
          multiple = FALSE
        )
      ),
      mainPanel(
      tabsetPanel(
        tabPanel("Linear Regression Model", mainPanel(fluidRow(
          column(
            12,
            verbatimTextOutput('lmSummary'),
            conditionalPanel(condition = "input.predictor_bar.length == 1",
                             plotOutput("SimpReg"))
          )
        ),  fluidRow(
          column(12, htmlOutput('by_hand')))),
        tabPanel("Model Predictions",
                
                 )))
      )
      )
    )
  )

