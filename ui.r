library(shiny)
library(class)
library(gmodels)
library(markdown)

shinyUI(pageWithSidebar(
  headerPanel("k Nearest Neighbors Example"),
  sidebarPanel(
    helpText(""),
    helpText(""),
    helpText("Pick 'k' Nearest Neighbors to Classify a Data Set"),
    helpText(""),
    helpText(""),
    helpText(""),
    helpText("Pick how to Scale the Data for Distance from Neighbor"),
    uiOutput("choose_scale"),
    helpText(""),
    helpText(""),
    helpText("Use CTRL-click to select multiple features"),
    uiOutput("choose_graph"),
    helpText(""),
    helpText(""),
    helpText(""),
    helpText("Pick the Number of Neighbors to Classify a 'Patient'"),
    uiOutput("choose_knn"),
    helpText(""),
    helpText(""),
    helpText("The Confusion Matrix shows Several Error Calculations for the Model")
  ),

  mainPanel(
    h3(textOutput('caption')),
    tabsetPanel(
      # Not how I wanted to do this, but renderHTML() would crash the rest of the app
      tabPanel("Intro", textOutput("intro1"), textOutput("intro2"), textOutput("intro3"),
               textOutput("intro4"), textOutput("intro5"), textOutput("intro6"),
               textOutput("intro7")),
      tabPanel("Data", dataTableOutput("filetable")),
      tabPanel("Stats", tableOutput("stattable")),
      tabPanel("Graphs", plotOutput("pairgraphs", height = 600)),
      tabPanel("Confusion Matrix", verbatimTextOutput("confusionmatrix"))


    )
   )
  )
)