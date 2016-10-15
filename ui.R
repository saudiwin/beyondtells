
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
require(shinythemes)

shinyUI(fluidPage(theme = shinytheme("sandstone"),

  # Application title
  titlePanel("Beyond Tells Interactive Data Visualization"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h2('Initial Database Exploration'),
      p('This page will host visualization, modeling and database management tools for the Beyondtells data.'),
      br(),
      actionButton('load',tags$b('Load Data Again')),
      width=2
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput('histplot'),
      DT::dataTableOutput('viewdata'))
    )
  )
)
