library(shiny)
options(shiny.maxRequestSize = 400*1024^2)

load('NLPModel.RData')
source('Requirements.R')
source('Prediction.R')
source('NGramTokenizer.R')

g.tm2 <<- proc.time()
g.tm3 <<- proc.time()

shinyServer(  
  function(input, output) {
    # builds a reactive expression that only invalidates 
    # when the value of input$goButton becomes out of date 
    # (i.e., when the button is pressed)
    ntext <- eventReactive(input$executeInput1, {
      input$input1
    })
    
    p.2 <- reactive({
	  g.tm2 <<- proc.time()  				
	  Sys.sleep(1.05)
      res <- Predict.2(input$input1,dt.2)
	  g.tm2 <<- proc.time() - g.tm2
	  return(res)
    })
    p.3 <- reactive({
	  g.tm3 <<- proc.time()  					
	  Sys.sleep(2.1)
      res <- Predict.3(input$input1,dt.3)
	  g.tm3 <<- proc.time() - g.tm3
	  return(res)
    })
    
    output$logo <- renderImage({
        return(list(
          src = "ALP_Logo4.gif",
          contentType = "gif",
          alt = "Face"
        ))
    }, deleteFile = FALSE)
      
    # You can access the value of the widget with input$senctenceToBeCompleted, e.g. 
    output$nlpModelInfo.2 <- renderPrint({
      return(head(p.2()$dt.pred))
    })
        
	# You can access the value of the widget with input$senctenceToBeCompleted, e.g. 
	output$nlpModelInfo.3 <- renderPrint({
		return(head(p.3()$dt.pred))
	})


    output$w2 <- renderPrint({
      
      lastOutput2 <- NULL
         
      completion <- p.2()$prediction
        
      lastOutput2 <- completion
      
      return(lastOutput2)
    }) 
    
    output$w3 <- renderPrint({
      
      lastOutput3 <- NULL      
      completion <- p.3()$prediction

      lastOutput3 <- completion
      
      return(lastOutput3)
    })      
        
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    output$wordcloud <- renderPlot({
      
      result <- p.2()
      result$dt.pred$w.length <- nchar(result$dt.pred$name1)
      result$dt.pred <- result$dt.pred[order(result$dt.pred$w.length)]
      w.length.max <- dim(result$dt.pred)[2]
	  if(!is.na(p.2()) & length(p.2) != 0) {
      	wordcloud_rep(result$dt.pred$name1,
                      result$dt.pred$c21,
                      scale=c(8,0.01),
                      max.words=40,
                      colors=brewer.pal(8, "Dark2"))
      }

      return(NULL)
    })
    
    output$predictedWord <- renderPrint({
        
      predictedWord <- p.3()$prediction
      if (is.na(predictedWord))
        predictedWord <- p.2()$prediction

      return(predictedWord)
    })
    
    output$completedSentence <- renderPrint({
        
      predictedWord <- p.3()$prediction
      if (is.na(predictedWord))
        predictedWord <- p.2()$prediction
        
      completedSentence <- paste(input$input1, predictedWord, tags$head(tags$style("#text1{color: red;}")))
	  #'style = color:blue')
      
      return(completedSentence)
    })
    
    output$tm <- renderPrint({
	  head(p.2()$dt.pred)
	  head(p.3()$dt.pred)
      return(g.tm3[[1]] + g.tm2[[1]])
    })    
    
    output$stopwords <- renderPrint({
      dt.sw <- data.table((stopwords("en")))
      dt.sw <- dt.sw[order(V1)]
      cat(as.character(dt.sw))
    })
  }
)