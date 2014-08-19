library(shiny)
library(class)
library(gmodels)
library(scales)
library(psych)
library(caret)
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

    output$intro <- renderPrint({print(intro)})           
     
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

  # Take all the inputs and generate the appropriate plot
      output$pairgraphs <- renderPlot(function() {
      temp <- cbind(as.factor(wbcd$diagnosis), Data()$orig[, input$features, drop = FALSE])
      temp[,1] <- as.factor(temp[,1])
      pairs.panels(temp[,2:ncol(temp)], bg = c("green", "purple")[temp[,1]],cex =2,
                   lwd = 2, pch = 21, main = "Green = Benign  Purple = Malignant")
       })
})