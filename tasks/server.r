library(shiny)
library(plotly)

source("tasks/genetic_algorithms.r")

server <- function(input, output, session) {
    observeEvent(input$run, {
        func <- input$func
        popSize <- input$popSize
        maxGen <- input$maxGen
        mutationRate <- input$mutationRate

        selection_method <- match.fun(input$selection)
        crossover_method <- match.fun(input$crossover)
        mutation_method <- match.fun(input$mutation)

        # Collect variable inputs dynamically
        variables <- list()
        for (i in 1:input$addVar) {
            var_id <- paste0("var", i)
            start_id <- paste0("start", i)
            end_id <- paste0("end", i)
            if (!is.null(input[[var_id]]) && !is.null(input[[start_id]]) && !is.null(input[[end_id]])) {
                variables[[input[[var_id]]]] <- c(input[[start_id]], input[[end_id]])
            }
        }

        if (length(variables) == 0) {
            output$error <- renderText("Error: Please add at least one variable.")
            return()
        }

        f <- function(x) eval(parse(text = func))

        output$functionPlot <- renderPlotly({
            x <- seq(variables[[1]][1], variables[[1]][2], length.out = 100)
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

    observeEvent(input$addVar, {
        var_id <- paste0("var", input$addVar)
        start_id <- paste0("start", input$addVar)
        end_id <- paste0("end", input$addVar)
        delete_id <- paste0("delete", input$addVar)
        row_id <- paste0("row", input$addVar)
        
        insertUI(
            selector = "#variableInputs",
            ui = tags$div(
                id = row_id,
                style = "display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;",
                textInput(var_id, "Variable (e.g., y)", width = "25%"),
                numericInput(start_id, "Start of Interval", value = 0, width = "25%"),
                numericInput(end_id, "End of Interval", value = 1, width = "25%"),
                actionButton(delete_id, "X", style = "background-color: red; color: white;")
            )
        )
        
        observeEvent(input[[delete_id]], {
            removeUI(selector = paste0("#", row_id))
        })
    })
}