
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("World self esteem plot"),

  fluidRow(column(4,
  								selectInput("plot",
  														choices = c("countries labelled"=1, "simple" = 2), #, "with GDP" = 3
  														label = "Choose plot",
  )),
  column(4,
  			 selectInput("age_range",
  			 						choices = c("All"="Across.Age", "16-19" = "Age.16...19", "20-24" = "Age.20...24","24-31" = "Age.24...30", "31-45" = "Age.31...45"),
  			 						label = "Age range",
  			 )),
  column(4,
  			 selectInput("zoom",
  			 						choices = c("World"=1, "Europe" = 2, "South America" = 3),
  			 						label = "Zoom in on",
  			 ))
  
  ),
  fluidRow(
  	column(12, 
  				 mainPanel(
  				 	plotOutput("distPlot", height = "700px"),
  				 	width = 12)
  	)
  )
))
