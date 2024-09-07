library(shiny)
library(shinythemes)
library(plotly)
source("tasks/global.r")

ui <- fluidPage(
    theme = shinytheme("darkly"),  
    titlePanel("Genetic Algorithm for Function Optimization"),
    sidebarLayout(
        sidebarPanel(
            textInput("func", "Function to Optimize", value = default_func),
            div(style = "display: flex; justify-content: center; align-items: center; height: 50px;",
                actionButton("addVar", "Add Variable"),
            ),
            uiOutput("variableInputs"),
            numericInput("popSize", "Population Size", value = default_popSize),
            numericInput("maxGen", "Max Generations", value = default_maxGen),
            numericInput("mutationRate", "Mutation Rate", value = default_mutationRate),
            selectInput("selection", "Selection Method", choices = c("gareal_lrSelection", "gareal_rwSelection", "gareal_tourSelection")),
            selectInput("crossover", "Crossover Method", choices = c("gareal_blxCrossover", "gareal_spCrossover", "gareal_oxCrossover")),
            selectInput("mutation", "Mutation Method", choices = c("gareal_raMutation", "gareal_nraMutation", "gareal_pmMutation")),
            
            div(style = "display: flex; justify-content: center; align-items: center; height: 50px;",
                actionButton("run", "Run Genetic Algorithm")
            ),
        ),
        mainPanel(
            plotlyOutput("functionPlot", height = "500px"), 
            plotlyOutput("maxFitnessPlot", height = "500px"),        
            plotlyOutput("minFitnessPlot", height = "500px"),        
            div(class = "table-container",
                tableOutput("resultsTable")
            ),
            tags$style(HTML("
                .table-container {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: auto; /* Adjust height to auto */
                }
                table {
                    width: 100%; /* Adjust width to 100% */
                    font-size: 18px;
                    border-collapse: collapse;
                    text-align: center;
                    background-color: #333;
                    color: white;
                }
                th, td {
                    padding: 10px;
                    border: 1px solid #ddd;
                }
            ")),

             fluidRow(
                column(12,
                    wellPanel(
                        h4("Best Fitness"),
                        textOutput("bestFitness")
                    ),
                    wellPanel(
                        h4("Best Solution"),
                        textOutput("bestSolution")
                    ),
                    wellPanel(
                        h4("Execution Time"),
                        textOutput("executionTime")
                    ),
                    wellPanel(
                        h4("Worst Solution"),
                        textOutput("worstSolution")
                    ),
                    wellPanel(
                        h4("Worst Fitness"),
                        textOutput("worstFitness")
                    ),
                           div(style = "display: flex; justify-content: space-between;",
                            wellPanel(
                                h4("Max Fitness Over Generations"),
                                textOutput("maxFitnessOverGenerations")
                            ),
                            wellPanel(
                                h4("Min Fitness Over Generations"),
                                textOutput("minFitnessOverGenerations")
                            )
                        )
                )
            )
        )
    )
)