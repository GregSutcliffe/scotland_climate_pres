#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(plotly)

# Static data loader ------------------------------------------------------
print('starting data load')

# Data sourced from the Met Office UKCP09 daily climate dataset
# These files contain 100 5km x 5km squares, we only want a specific square
# so we select the right column and rename it
temp <- read.csv('ukcp09_gridded-land-obs-daily_timeseries_mean-temperature_250000E_700000N_19600101-20161231.csv', header = F)
temp <- temp %>%
  select(V1,V79) %>%
  filter(V1 != 'easting' & V1 != 'northing') %>%
  mutate(V1 = ymd(V1)) %>%
  rename(date = V1,mean_temp_celsius = V79) %>%
  mutate(year = as.factor(year(date)))
summary_temp = temp %>%
  group_by(year) %>%
  summarise(mean = mean(mean_temp_celsius)) %>%
  mutate(year2 = as.Date(year,tryFormats=c('%Y')))

rain <- read.csv('ukcp09_gridded-land-obs-daily_timeseries_rainfall_250000E_700000N_19580101-20161231.csv', header = F)
rain <- rain %>%
  select(V1,V79) %>%
  filter(V1 != 'easting' & V1 != 'northing') %>%
  mutate(V1 = ymd(V1)) %>%
  rename(date = V1,rainfall = V79) %>%
  mutate(year = as.factor(year(date)))
summary_rain = rain %>%
  group_by(year) %>%
  summarise(mean = mean(rainfall)) %>%
  mutate(year2 = as.Date(year,tryFormats=c('%Y')))

print('loaded data')

# Main app ----------------------------------------------------------------

shinyServer(function(input, output) {
  
# Temperature Graphs ------------------------------------------------------
  output$plot_temp <- renderPlotly({
    x <- filter(temp,year == input$slider_temp)

    # plot the daily temp graph
    p = ggplot(x,aes(x=date,y=mean_temp_celsius,colour=year)) +
      geom_point() +
      geom_smooth(se=F,colour='blue') +
      ylab('Mean Temperature (Celsius)') +
      xlab('Date')

    ggplotly(p, tooltip = c('y','x')) %>%
      layout(showlegend = F)
  })
  output$all_temp <- renderPlotly({
    
    x = filter(summary_temp, year == input$slider_temp)
    # plot the overall temp graph
    a = ggplot(summary_temp,aes(x=year2,y=mean,colour=I('black'),label=year)) +
      geom_point() +
      geom_point(data = x, colour=I('red')) +
      geom_smooth(se=F,method='lm') +
      ylab('Mean Temperature (Celsius)') +
      xlab('Year')
    
    
    ggplotly(a, tooltip = c('y','label')) %>%
      layout(showlegend = F)
  })
  # Rainfall Graphs ------------------------------------------------------
  output$plot_rain <- renderPlotly({
    x <- filter(rain,year == input$slider_rain)
    
    # plot the daily rain graph
    p = ggplot(x,aes(x=date,y=rainfall,colour=year)) +
      geom_point() +
      geom_smooth(se=F,colour='blue') +
      ylab('Mean Rainfall (millimetres)') +
      xlab('Year')
    
    
    ggplotly(p, tooltip = c('y','x')) %>%
      layout(showlegend = F)
  })
  output$all_rain <- renderPlotly({
    
    x = filter(summary_rain, year == input$slider_rain)
    # plot the overall rainfall graph
    a = ggplot(summary_rain,aes(x=year2,y=mean,colour=I('black'),label=year)) +
      geom_point() +
      geom_point(data = x, colour=I('red')) +
      geom_smooth(se=F,method='lm') +
      ylab('Mean Rainfall (millimetres)') +
      xlab('Date')
    
    ggplotly(a, tooltip = c('y','label')) %>%
      layout(showlegend = F)
  })
  
})