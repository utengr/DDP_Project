library(shiny)
library(class)
library(gmodels)
library(markdown)
library(e1071)

# Load, lean data, and creat data.frames
wbcd <- read.csv("wisc_bc_data.csv", stringsAsFactors = FALSE)
wbcd <- wbcd[-1]
Diagnosis <- wbcd[,1]
wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c("B", "M"), labels = c("Benign", "Malignant"))
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]
normalize <- function(x) {return ((x - min(x)) / (max(x) - min(x)))}
wbcd_raw <- as.data.frame(wbcd[-1])
wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))
wbcd_z <- as.data.frame(scale(wbcd[-1]))
colnames = names(wbcd_raw)

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
    # Pick Scaling Option for Data
    # Pick how to scale or no scale on data
    radioButtons("scale", "Choose Scale for Data",
                   c("No Scale" = "noscale", "Normalization" = "normal",
                     "Z-Score" = "zscore"), selected = "No Scale"),
    helpText(""),
    helpText(""),
    helpText("Use CTRL-click to select multiple features"),
    # Pick feature with dropdown
    # Pick the features to plot in Pair Graphs
    selectInput("features", "Features to Pair Graph",
                choices = colnames,
                selected = c(colnames[1],colnames[2],colnames[3]),
                multiple = TRUE),
    
    helpText(""),
    helpText(""),
    helpText(""),
    helpText("Pick the Number of Neighbors to Classify a 'Patient'"),
    # Pick knn value with Slider
    # Pick the number of neighbors
    sliderInput("knnval", "Choose the number of Neightbors (k)",
                min = 1, max = 25, value = 5, step = 1),
    helpText(""),
    helpText(""),
    helpText("The Confusion Matrix shows Several Error Calculations for the Model")
  ),

  mainPanel(
    h3(textOutput('caption')),
    tabsetPanel(
      tabPanel("Intro", includeHTML("intro.html")),
      tabPanel("Data", dataTableOutput("filetable")),
      tabPanel("Stats", tableOutput("stattable")),
      tabPanel("Graphs", plotOutput("pairgraphs", height = 600)),
      tabPanel("Confusion Matrix", verbatimTextOutput("confusionmatrix"))


    )
   )
  )
)