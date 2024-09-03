source("tasks/global.r")
source("tasks/ui.r")
source("tasks/server.r")

shinyApp(ui = ui, server = server)