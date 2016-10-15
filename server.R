# Beyond Tells Data Analysis
# V0.1 Robert Kubinec

library(shiny)
require(RPostgreSQL)
require(plotly)



# Values that need to set for the whole package
readRenviron('.Renviron')
drv <- dbDriver("PostgreSQL")




loadData <- function(tablename) {
  # Connect to the database
  con <- dbConnect(drv, dbname = Sys.getenv('DATABASE'),
                   host=Sys.getenv('POSTGRES_SERVER'),
                   user=Sys.getenv('POSTGRES_USER'),
                   password=Sys.getenv('POSTGRES_PASSWORD'))

  if(tablename=="Original") {
    tablename <- table
  }
  
  # Check to make sure table exists
  
  validate(need(dbExistsTable(con,tablename),message='The requested table does not exist in the server.'))
  
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", tablename)
  # Submit the fetch query and disconnect
  data <- dbGetQuery(con, query)
  dbDisconnect(con)
  data
}

# When session ends, close down db connection



shinyServer(function(input, output,session) {
  
  update_data <- eventReactive(input$load,{
    loadData(Sys.getenv('DATATABLE'))
  },ignoreNULL=FALSE)

  output$viewdata <- DT::renderDataTable({
    update_data()
    })
  
  output$histplot <- renderPlotly({
    plot_ly(update_data(),x=~action) %>% add_histogram()
  })
  
  
  cancel.onSessionEnded <- session$onSessionEnded(function() {
    dbDisconnect(con)
  })

})
