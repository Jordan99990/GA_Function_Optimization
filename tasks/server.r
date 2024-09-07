library(shiny)
library(plotly)

source("tasks/genetic_algorithms.r")

server <- function(input, output, session) {
    observeEvent(input$run, {
        func <- input$func
        popSize <- input$popSize
        maxGen <- input$maxGen
        mutationRate <- input$mutationRate
        startInterval <- input$startInterval
        endInterval <- input$endInterval

        selection_method <- match.fun(input$selection)
        crossover_method <- match.fun(input$crossover)
        mutation_method <- match.fun(input$mutation)

        variables <- list(
            x = c(startInterval, endInterval)
        )

        f <- function(x) eval(parse(text = func))

        output$functionPlot <- renderPlotly({
            x <- seq(startInterval, endInterval, length.out = 100)
            y <- sapply(x, f)
            plot_ly(x = ~x, y = ~y, type = 'scatter', mode = 'lines') %>%
                layout(title = "Function Plot")
        })

        start_time <- Sys.time()
        ga_results <- tryCatch({
            run_genetic_algorithm(
                func, variables, popSize, maxGen, mutationRate,
                selection = selection_method,
                crossover = crossover_method,
                mutation = mutation_method
            )
        }, error = function(e) {
            print(e)
            NULL
        })
        end_time <- Sys.time()

        if (is.null(ga_results)) {
            output$error <- renderText("Error in running genetic algorithm")
            output$executionTime <- renderText({
                "Error in running genetic algorithm"
            })
            return()
        }

        output$resultsTable <- renderTable({
            ga_results$results
        })

        output$bestFitness <- renderText({
            paste("Best Fitness:", ga_results$best_fitness)
        })

        output$bestSolution <- renderText({
            paste("Best Solution:", ga_results$best_solution)
        })

        output$executionTime <- renderText({
            paste("Execution Time:", difftime(end_time, start_time, units = "secs"))
        })

        output$worstSolution <- renderText({
            paste("Worst Solution:", ga_results$worst_solution)
        })

        output$worstFitness <- renderText({
            paste("Worst Fitness:", ga_results$worst_fitness)
        })

        output$maxFitnessOverGenerations <- renderText({
            paste("Max Fitness Over Generations:", toString(ga_results$max_fitness_over_generations$Fitness))
        })

        output$minFitnessOverGenerations <- renderText({
            paste("Min Fitness Over Generations:", toString(ga_results$min_fitness_over_generations$Fitness))
        })

        output$maxFitnessPlot <- renderPlotly({
            plot_ly(data = ga_results$max_fitness_over_generations, x = ~Generation, y = ~Fitness, type = 'scatter', mode = 'lines') %>%
                layout(title = "Max Fitness Over Generations")
        })

        output$minFitnessPlot <- renderPlotly({
            plot_ly(data = ga_results$min_fitness_over_generations, x = ~Generation, y = ~Fitness, type = 'scatter', mode = 'lines') %>%
                layout(title = "Min Fitness Over Generations")
        })
    })
}