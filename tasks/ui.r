library(shiny)
library(shinythemes)
source("tasks/global.r")

ui <- fluidPage(
    theme = shinytheme("darkly"),  
    titlePanel("Genetic Algorithm for Function Optimization"),
    sidebarLayout(
        sidebarPanel(
            textInput("func", "Function (in terms of x):", default_func),
            numericInput("start", "Interval Start:", default_start),
            numericInput("end", "Interval End:", default_end),
            numericInput("popSize", "Population Size:", default_popSize),
            numericInput("maxGen", "Max Generations:", default_maxGen),
            numericInput("mutationRate", "Mutation Rate:", default_mutationRate),
            div(style = "display: flex; justify-content: center; align-items: center; height: 50px;",
                actionButton("run", "Run Genetic Algorithm")
            )
        ),
        mainPanel(
            plotOutput("functionPlot", height = "500px"), 
            plotOutput("gaPlot", height = "500px"),        
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
                th {
                    background-color: #555;
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