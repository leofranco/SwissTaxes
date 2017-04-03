library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # Application title
  titlePanel("Withholding tax in Switzerland: comparison between cantons"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("perfrancs", label = h5("Display amount in"), choices = list("Percentage" = 1, "Swiss Francs" = 2), selected = 1),    
      selectInput("church", label = h5("Church Tax"), choices = list("With" = 1, "Without" = 2), selected = 2),    
      selectInput("rate", label = h5("Personal status"), choices = list("Single" = 1, "Married with one revenue" = 2, "Married with two revenues" = 3), selected = 1),    
      sliderInput("children", label = h5("Number of children"), min = 0, max = 4, value = 0),    
      sliderInput("salary", label = h5("Gross monthly salary in francs"), min = 1000, max = 20000, value = 10000, step=500)    
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
    	h4("Select the categories that apply to you on the left to see below what would be your taxes in the different regions in Switzerland."),
      plotOutput("taxPlot")
    )
  )
))