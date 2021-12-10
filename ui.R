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
    "Statistical Analysis",
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
      ),
      textInput("values", h4("Enter Predictor Values (seperated by comma)"))
    ),
    
    
    mainPanel(fluidRow(
      column(
        12,
        verbatimTextOutput('lmSummary'),
        conditionalPanel(condition = "input.predictor_bar.length == 1",
                         plotOutput("SimpReg"))
      )
    ),  fluidRow(column(
      12, withMathJax(h3(htmlOutput('by_hand')))
    )),
    verbatimTextOutput("predictions")
    )
  )
)



