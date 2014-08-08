library(shiny)
library(class)
library(gmodels)
library(scales)
library(psych)
library(caret)
library(markdown)

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

intro1 <- "This Shiny application is a demonstration of the k Nearest Neighbor (kNN) classification algorithm.  kNN is a 'lazy' learner such that it simply takes the descriptive variables of an item, find the nearest k neighbors, where k is the number of neighbors, and classifies the item the same as the majority of the selected neighbors. The challenge for the practitioner is how to define 'distance'. With n descriptive variables, the curse of dimensionality becomes more of a problem as n increase. In two dimensions, the distance can simply be calculated as the square root of the sum of squared differences between the dimensions. But as n increases, this distance can grow to such a point that all points are distant from the item."

intro2 <- "Additionally, one must be careful that the units of a variable do not overpower the distance calculation.  One way to resolve this is to scale the variables so they are all between 0 and 1 or to convert them to a normalized distribution by subtracting the mean of the variable in the entire set from each point and dividing the difference by the standard deviation of the variable in the entire set."

intro3 <- "The Data tab displays the raw data used for the application.  It data is a sample of the Breast Cancer Wisconsin (Diagnostic) Data Set, located on the UCI Machine Learning Repository, found at https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+%28Diagnostic%29. The app allows you to scale the data by normalization (0-1) or by Z-score by using the radio buttons on the left."

intro4 <- "The Stats tab calculates 6 point descriptive statistics of each variable used in algorithm. The statistics will change as you change the scaling function."

intro5 <- "The Graphs tab displays relationships between the various variables.  You can select the choice and number of variables to compare in the drop down menu to the left. Highlighted variables are used in the graphs.  Hold down the CTRL key to select/un-select variables. The variables are shown in scatterplots, histograms, density plots, and rug plots.  Additionally, the correlation coefficient is calculated for each pair and shown in the upper diagonal. Note that there must be more than one (1) variable selected for the graph to function."

intro6 <- "The Confusion Matrix tab displays how well the algorithm is working.  A subset of 100 observations was held out of the dataset, and the algorithm is used to predict if the sample is Benign or Malignant.  Various measure of the 'goodness' of the model are also included."

intro7 <- "You can change the number of neighbors used in the prediction by moving the slider. Also note the change of predictions at certain k values when you change the scaling technique."

shinyServer(function(input, output) {
   #Start Breaking up data
     Data <- reactive({
         dat = wbcd_n
         knnvalue <- as.integer(input$knnval)
         if(input$scale == "normal") {dat <- wbcd_n}
         if(input$scale == "zscore") {dat <- wbcd_z}
         if(input$scale == "noscale") {dat <- wbcd_raw}
         wbcd_train <- dat[1:469, ]
         wbcd_test <- dat[470:569, ]
         wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test,
                               cl = wbcd_train_labels, k=knnvalue)
         colnames = names(dat)
         info <- list(orig = dat, colnames = colnames,
                      pred = wbcd_test_pred, test = wbcd_test_labels)
         return(info)
     })

    output$intro1 <- renderPrint({print(intro1)}) 
    output$intro2 <- renderPrint({print(intro2)})
    output$intro3 <- renderPrint({print(intro3)})
    output$intro4 <- renderPrint({print(intro4)}) 
    output$intro5 <- renderPrint({print(intro5)})
    output$intro6 <- renderPrint({print(intro6)})
    output$intro7 <- renderPrint({print(intro7)})
     
   #Create summary of data in a Data Table
     output$filetable <- renderDataTable({
        as.data.frame(cbind(Diagnosis, Data()$orig))
     })

   #Create Summary Statistics of Data
     output$stattable <- renderTable({
     summary(as.data.frame(cbind(Diagnosis, Data()$orig)))
     })
     
   #Create Confusion Matrix of Predictions
     output$confusionmatrix <- renderPrint({
     confusionMatrix(Data()$test, Data()$pred)
     })

  # Pick Scaling Option for Data
      output$choose_scale <- renderUI(function() {
        # Pick how to scale or no scale on data
        radioButtons("scale", "Choose Scale for Data",
                     c("No Scale" = "noscale", "Normalization" = "normal",
                       "Z-Score" = "zscore"), selected = "No Scale")
      })

  # Pick feature with dropdown
      output$choose_graph <- renderUI(function() {
        # Pick the features to plot in Pair Graphs
        selectInput("features", "Features to Pair Graph",
                    choices = Data()$colnames,
                    selected = c(Data()$colnames[1],Data()$colnames[2], Data()$colnames[3]),
                    multiple = TRUE)
      })

  # Pick knn value with Slider
      output$choose_knn <- renderUI(function() {
        # Pick the number of neighbors
        sliderInput("knnval", "Choose the number of Neightbors (k)",
            min = 1, max = 25, value = 5, step = 1)
      })

  # Take all the inputs and generate the appropriate plot
      output$pairgraphs <- renderPlot(function() {
      temp <- cbind(as.factor(wbcd$diagnosis), Data()$orig[, input$features, drop = FALSE])
      temp[,1] <- as.factor(temp[,1])
      pairs.panels(temp[,2:ncol(temp)], bg = c("green", "purple")[temp[,1]],cex =2,
                   lwd = 2, pch = 21, main = "Green = Benign  Purple = Malignant")
       })
})