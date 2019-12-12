library(shiny)

shinyUI(fluidPage(
    titlePanel("Predict Iris Species"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("slidersplit", "Percentage of Training Data", 30, 98, value = 80),
            radioButtons("models", "Model:",
                         c("Multinomial Logistic Regression" = "lr",
                           "Random Forest" = "rf")),
            radioButtons("features", "Features to display:",
                         c("Sepal Length/Width" = "sepal",
                           "Petal Length/Width" = "petal")),
            submitButton("Submit"),
            h3("Usage:"),
            p("With this App you can interactively test models on the Iris dataset. 
              Choose the percentage of training data you want to use, your model for the predictions 
              and the features to be displayed. Press the Submit button to update your selection.")
        ),
        mainPanel(
            h3("Right and Wrong Predictions:"),
            p("Shows which datapoints have been rightly and wrongly predicted on the testing data."),
            plotOutput("plot_pred"),
            h3("Training and Testing Data:"),
            p("Shows which datapoints belong to the training and testing data."),
            plotOutput("plot_tt"),
            h3("Original Species:"),
            p("Shows the original species."),
            plotOutput("plot_o"),
            h3("Accuracy:"),
            textOutput("acc")
        )
    )
))