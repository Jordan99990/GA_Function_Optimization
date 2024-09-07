library(shiny)
library(ggplot2)
library(GA)
library(plotly)

# Hyperparameters
default_func <- "x^2"
default_startInterval <- -10
default_endInterval <- 10
default_popSize <- 150
default_maxGen <- 1000
default_mutationRate <- 0.69