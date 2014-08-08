---
output: pdf_document
---
This Shiny application is a demonstration of the k Nearest Neighbor (kNN) classification algorithm.  kNN is a 'lazy' learner such that it simply takes the descriptive variables of an item, find the nearest k neighbors, where k is the number of neighbors, and classifies the item the same as the majority of the selected neighbors.  The challenge for the practitioner is how to define 'distance'.  With n descriptive variables, the curse of dimensionality becomes more of a problem as n increase.  In two dimensions, the distance can simply be calculated as the square root of the sum of squared differences between the dimensions.  But as n increases, this distance can grow to such a point that all points are distant from the item.  

Additionally, one must be careful that the units of a variable do not overpower the distance calculation.  One way to resolve this is to scale the variables so they are all between 0 and 1 or to convert them to a normalized distribution by subtracting the mean of the variable in the entire set from each point and dividing the difference by the standard deviation of the variable in the entire set.  

The Data tab displays the raw data used for the application.  It data is a sample of the [Breast Cancer Wisconsin (Diagnostic) Data Set](https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+%28Diagnostic%29), located on the UCI Machine Learning Repository.   The app allows you to scale the data by normalization (0-1) or by Z-score by using the radio buttons on the left.  

The Stats tab calculates 6 point descriptive statistics of each variable used in algorithm.  The statistics will change as you change the scaling function.  

The Graphs tab displays relationships between the various variables.  You can select the choice and number of variables to compare in the drop down menu to the left.  Highlighted variables are used in the graphs.  Hold down the CTRL key to select/un-select variables.  The variables are shown in scatterplots, histograms, density plots, and rug plots.  Additionally, the correlation coefficient is calculated for each pair and shown in the upper diagonal.  Note that there must be more than one (1) variable selected for the graph to function.  

The Confusion Matrix tab displays how well the algorithm is working.  A subset of 100 observations was held out of the dataset, and the algorithm is used to predict if the sample is Benign or Malignant.  Various measure of the 'goodness' of the model are also included.  

You can change the number of neighbors used in the prediction by moving the slider.  Also note the change of predictions at certain k values when you change the scaling technique.  
