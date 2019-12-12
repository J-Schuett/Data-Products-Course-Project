library(shiny)
library("RColorBrewer")
library(caret)
library(nnet)

shinyServer(function(input, output) {
    #create reactive training and testing data
    inTrain <- reactive({
        spl <- input$slidersplit*0.01
        createDataPartition(y=iris$Species, p=spl, list=FALSE)
    })
    training <- reactive({
        iris[inTrain(),]
    })
    testing <- reactive({
        testing <- iris[-inTrain(),]
    })
    
    #create reactive predictions depending on the chosen model
    pred <- reactive({
        if(input$models == "lr"){
            model <- nnet::multinom(Species ~., data = training())
            return(predict(model, testing()))
        }
        else{
            model <- train(Species ~., data = training(), method="rf")
            return(predict(model, testing()))
        }
    })
        
    #plot training and testing datapoints
    output$plot_tt <- renderPlot({
        if(input$features=="sepal"){
            ft <- c("Sepal.Length","Sepal.Width")
            xlim <- c(3.2,8.0)
            ylim <- c(1.9,4.5)}
        else{
            ft <- c("Petal.Length","Petal.Width")
            xlim <- c(0.9,7.0)
            ylim <- c(0,2.6)
        }
        xlab <- sub("\\.", " ", ft[1])
        ylab <- sub("\\.", " ", ft[2])
        
        plot(training()[,ft[1]], training()[,ft[2]], xlab = xlab, 
             ylab = ylab, bty = "n", pch = 16, col = "Red", xlim = xlim, ylim = ylim
        )
        points(testing()[,ft[1]], testing()[,ft[2]], bty = "n", pch = 16, col = "Black")
        legend(x="topleft", legend=c("Testing","Training"), pch = 16, 
               col = 1:2, bty = "n", cex = 1.2)
    })
    
    #plot original iris species data
    output$plot_o <- renderPlot({
        if(input$features=="sepal"){
            ft <- c("Sepal.Length","Sepal.Width")
            xlim <- c(3.2,8.0)
            ylim <- c(1.9,4.5)}
        else{
            ft <- c("Petal.Length","Petal.Width")
            xlim <- c(0.9,7.0)
            ylim <- c(0,2.6)
        }
        xlab <- sub("\\.", " ", ft[1])
        ylab <- sub("\\.", " ", ft[2])
        
        palette(brewer.pal(n = 3, name = "Set2"))
        plot(iris[,ft[1]], iris[,ft[2]], xlab = xlab, 
             ylab = ylab, bty = "n", pch = 16, col = iris$Species,
             xlim = xlim, ylim = ylim
             )
        legend(x="topleft", legend=levels(iris$Species), pch = 16, 
                      col = 1:3, bty = "n", cex = 1.2)
    })
    
    #plot right and wrong predictions on the testing set
    output$plot_pred <- renderPlot({
        if(input$features=="sepal"){
            ft <- c("Sepal.Length","Sepal.Width")
            xlim <- c(3.2,8.0)
            ylim <- c(1.9,4.5)}
        else{
            ft <- c("Petal.Length","Petal.Width")
            xlim <- c(0.9,7.0)
            ylim <- c(0,2.6)
        }
        xlab <- sub("\\.", " ", ft[1])
        ylab <- sub("\\.", " ", ft[2])
        
        palette("default")
        correct_pred <- (pred() == testing()$Species)
        plot(testing()[,ft[1]], testing()[,ft[2]], xlab = xlab, 
             ylab = ylab, bty = "n", pch = 16,
             xlim = xlim, ylim = ylim)
        points(testing()[!correct_pred,ft[1]], testing()[!correct_pred,ft[2]], 
               bty = "n", pch = 16, col = "Red")
        legend(x="topleft", legend=c("Right","Wrong"), pch = 16, 
               col = 1:2, bty = "n", cex = 1.2)
    })
    
    output$acc <- renderText({
        mean(pred()==testing()$Species)
    })
})