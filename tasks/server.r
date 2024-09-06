library(shiny)
library(ggplot2)

source("tasks/genetic_algorithms.r")

server <- function(input, output) {
    observeEvent(input$run, {
        func <- input$func
        start <- input$start
        end <- input$end
        popSize <- input$popSize
        maxGen <- input$maxGen
        mutationRate <- input$mutationRate

        selection_method <- match.fun(input$selection)
        crossover_method <- match.fun(input$crossover)
        mutation_method <- match.fun(input$mutation)

        if (!is.finite(start) || !is.finite(end)) {
            output$error <- renderText("Error: 'start' and 'end' must be finite values.")
            return()
        }

        f <- function(x) eval(parse(text = func))

        output$functionPlot <- renderPlot({
            x <- seq(start, end, length.out = 100)
            y <- sapply(x, f)
            ggplot(data.frame(x, y), aes(x, y)) +
                geom_line() +
                ggtitle("Function Plot")
        })

        start_time <- Sys.time()
        ga_results <- tryCatch({
            run_genetic_algorithm(
                func, start, end, popSize, maxGen, mutationRate,
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

        output$gaPlot <- renderPlot({
            gridExtra::grid.arrange(ga_results$max_plot, ga_results$min_plot, ncol = 1)
        })
    })
}