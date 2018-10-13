#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Scotland Temperature / Rainfall Data, 1960 - 2016"),
  navbarPage("Plots",
    tabPanel("Mean Temperatures",
      sidebarLayout(
        sidebarPanel(
          p('This graph explores the temperatures recorded for Crieff,',
            'Scotland over the last 50 years'),
          p('The upper graph displays the daily mean temperature (in',
            'Celsius) for the selected year, so that you can see the',
            'distribution of values. A Loess curve is fitted to give',
            'some indication of the year`s characteristics.'),
          p('The lower graph shows the mean temperature for every year',
            'in the dataset, but highlights the selected year in red. A',
            'linear fit is also shown to give an indication of whether the',
            'year is above or below the expected mean.'),
          sliderInput("slider_temp", label = h3("Select Year"), min = 1960, 
                      max = 2016, value = 2000, sep ='')
        ),
        # Show a plot of the generated distribution
        mainPanel(
          plotlyOutput("plot_temp"),
          plotlyOutput("all_temp")
        )
      )
    ),
    tabPanel("Rainfall",
      sidebarLayout(
        sidebarPanel(
          p('This graph explores the rainfall recorded for Crieff,',
            'Scotland over the last 50 years'),
          p('The upper graph displays the daily rainfall (in',
            'millimetres) for the selected year, so that you can see the',
            'distribution of values. A Loess curve is fitted to give',
            'some indication of the year`s characteristics.'),
          p('The lower graph shows the mean rainfall for every year',
            'in the dataset, but highlights the selected year in red. A',
            'linear fit is also shown to give an indication of whether the',
            'year is above or below the expected mean.'),
          sliderInput("slider_rain", label = h3("Select Year"), min = 1960, 
                      max = 2016, value = 2000, sep ='')
        ),
        # Show a plot of the generated distribution
        mainPanel(
          plotlyOutput("plot_rain"),
          plotlyOutput("all_rain")
        )
      )
    )
  )
))