library(shiny)
library(skimr)
library(MASS)
library(dplyr)
library(splines)


function(input, output, session) {
  
    data <- MASS::wtloss
    x <- data$Days
    y <- data$Weight
    
    output$distPlot <- renderPlot({
        plot(x, y, type = 'p', xlab = "Nombre de jours", ylab = "Perte de poids (Kg)")
    })
    output$summary <- renderPrint(skim(data))

    modele <- lm(y~x)
    output$model_output <- renderPrint(summary(modele))
    output$model_graph <- renderPlot({
      plot(x, modele$residuals, ylab = "résidus", xlab = "")
      abline(h = 0, lty = 2)
      abline(h = 2, lty = 2, col = "red")
      abline(h = -2, lty = 2, col = "red")
    })
    
    observe({
      if (isTruthy(input$degre) & input$degre > 1) {
        for (i in 2:input$degre) {
          cols <- x^i
          data[paste0("Days^", i)] <- cols
        }
        modele1 <- lm(Weight~., data = data)
        output$model_output1 <- renderPrint(summary(modele1))
        output$model_graph1 <- renderPlot({
          plot(x, modele1$residuals, ylab = "résidus", xlab = "")
          abline(h = 0, lty = 2)
          abline(h = 2, lty = 2, col = "red")
          abline(h = -2, lty = 2, col = "red")
        })
        
        output$model_graph2 <- renderPlot({
          plot(x, y, type = 'p', ylab = "Weight (kg)", xlab = "Days", ylim = c(110, 200),
               xlim = c(0, 300), lty = 1, main = "Ajustement linéaire")
          points(x, predict(modele1), col = "red", pch = "*")
          lines(x, predict(modele1), col = "red", lty = 2)
        })
      }
    })
    
    observe(
      if (input$NonLin == "1"){
        wtloss.st <- c(b0 = 90, b1 = 95, th = 120)
        mod_nnlin <- nls(Weight ~ b0 + b1*2^(-Days/th), data = data, start = wtloss.st, trace = T)
        output$model_output2 <- renderPrint(summary(mod_nnlin))
        output$model_graph3 <- renderPlot({
          plot(x, y, type = 'p', ylab = "Weight (kg)", xlab = "Days", ylim = c(110, 200),
               xlim = c(0, 300), lty = 1, main = "Ajustement linéaire")
          points(x, predict(mod_nnlin), col = "red", pch = "*")
          lines(x, predict(mod_nnlin), col = "red", lty = 2)
        })
      }else{
        Bt <- bs(x)
        mod_splines <- lm(y~Bt)

        output$model_output2 <- renderPrint(summary(mod_splines))
        output$model_graph3 <- renderPlot({
          plot(x, y, type = 'p', ylab = "Weight (kg)", xlab = "Days", ylim = c(110, 200),
               xlim = c(0, 300), lty = 1, main = "Ajustement linéaire")
          points(x, predict(mod_splines), col = "red", pch = "*")
          lines(x, predict(mod_splines), col = "red", lty = 2)
        })
      }
    )


}
