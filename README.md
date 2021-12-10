# WHO-Life-Expectancy
Public health experts have coined the term "Social Determinants of Health" in order to understand how educational, governmental, and social institutions affect communities' overall health. This project aims to incorporate this concept with educational and economic data amongst public health information, in order to further understand the characteristics influencing a country's life expectancy. 

The features used in this dataset include immunization rates, years of schooling, economic development status, average BMI among other metrics.

## Dataset Citation
Rajarshi, K. (2018, February). Life Expectancy (WHO): Statistical Analysis on factors influencing Life Expectancy, Version 1. Retrieved December 7, 2021 from https://www.kaggle.com/kumarajarshi/life-expectancy-who/version/1.


## App Instructions

### Run App Locally
Recommendations:
* R >= 4.1.2
* Shiny >= 1.7.1

```
install.packages("shiny")
library(shiny)
shiny::runGitHub(repo = "WHO-Life-Expectancy",username = "samuel-gerstein",ref="main")
```

### Run App via shinyapps.io

## App Tutorial
* Descriptive Statistics
  - Filter Data by Country and/or Year
  - Calculate the Mean, Median, or Standard Deviation of the Data by Year, Country, or Development Status
* Visualization
  - View BMI, Life Expectancy, and Development Status using scatterplots, boxplots, and faceted boxplots.
* Statistical Analysis
  - Compute simple or multiple linear regression for any variables of your choice. The line of best fit for the chosen model is provided.
  - Use linear regression model to make predictions on user-provided data.
  - (Simple Linear Regression) View regression line on a scatterplot.

