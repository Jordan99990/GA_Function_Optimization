library(shiny)
library(ggplot2)
library(GA)

# Hiperparameters
default_func <- "x"
default_start <- -10
default_end <- 10
default_popSize <- 50
default_maxGen <- 100
default_mutationRate <- 0.1