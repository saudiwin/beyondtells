# Beyond Tells Data Analysis
# V0.1 Robert Kubinec

library(shiny)
require(RPostgreSQL)


loadData <- function(tablename) {
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  if(tablename=="Original") {
    tablename <- table
  }
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", tablename)
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

shinyServer(function(input, output) {

  output$viewdata <- DT::renderDataTable({

    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })

})
