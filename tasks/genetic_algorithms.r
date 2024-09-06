run_genetic_algorithm <- function(func, start, end, popSize, maxGen, mutationRate, selection = gareal_lrSelection, crossover = gareal_blxCrossover, mutation = gareal_raMutation) {
    f <- function(x) eval(parse(text = func))
    
    start_time <- Sys.time()
    
    ga_max <- ga(
        type = "real-valued",
        fitness = function(x) f(x), 
        lower = start,
        upper = end,
        popSize = popSize,
        maxiter = maxGen,
        pmutation = mutationRate,
        selection = selection,
        crossover = crossover,
        mutation = mutation
    )
    
    ga_min <- ga(
        type = "real-valued",
        fitness = function(x) -f(x), 
        lower = start,
        upper = end,
        popSize = popSize,
        maxiter = maxGen,
        pmutation = mutationRate,
        selection = selection,
        crossover = crossover,
        mutation = mutation
    )
    
    end_time <- Sys.time()
    execution_time <- end_time - start_time
    
    max_value <- ga_max@solution
    max_fitness <- f(max_value)
    min_value <- ga_min@solution
    min_fitness <- f(min_value)
    
    max_fitness_values <- ga_max@fitness
    min_fitness_values <- -ga_min@fitness
    
    max_df <- data.frame(Generation = 1:length(max_fitness_values), Fitness = max_fitness_values)
    min_df <- data.frame(Generation = 1:length(min_fitness_values), Fitness = min_fitness_values)
    
    max_plot <- plot_ly(max_df, x = ~Generation, y = ~Fitness, type = 'scatter', mode = 'lines', line = list(color = 'blue')) %>%
        layout(title = "Maximization Fitness Over Generations", xaxis = list(title = "Generation"), yaxis = list(title = "Fitness"))
    
    min_plot <- plot_ly(min_df, x = ~Generation, y = ~Fitness, type = 'scatter', mode = 'lines', line = list(color = 'red')) %>%
        layout(title = "Minimization Fitness Over Generations", xaxis = list(title = "Generation"), yaxis = list(title = "Fitness"))

    list(
        results = data.frame(
            Type = c("Maximum", "Minimum"),
            Value = c(max_value, min_value),
            Fitness = c(max_fitness, min_fitness)
        ),
        ga_max = ga_max,
        best_fitness = max_fitness,
        best_solution = max_value,
        execution_time = execution_time,
        worst_solution = min_value,
        worst_fitness = min_fitness,
        max_fitness_over_generations = max_df,
        min_fitness_over_generations = min_df,
        max_plot = max_plot,
        min_plot = min_plot
    )
}