library(shiny)
shinyUI(pageWithSidebar(
  # Application title
  h1("Word Predcition", align = "center"),  

  sidebarPanel( 
    fluidRow(column(4,imageOutput("logo", height = 100))),
	h3(' Input section '),   	
    h3(' Sentence to be completed: '),
    # Copy the line below to make a text input box
    textInput("input1", 
              label = "",#h3("Sentence to be completed:"), 
              value = ""),
    
    # Copy the line below to make an action button
    submitButton("Submit") 
  ),
  
  mainPanel(
    tabsetPanel(type = "tabs", 
                tabPanel("Prediction", 
						 h3(' Predicted word ', color="red"),
						 fluidRow(column(5, verbatimTextOutput("predictedWord")), column(5,plotOutput("wordcloud"))),
                         h3(' Completed sentence ', tags$head(tags$style("#text1{color: red;}"))),
                         fluidRow(column(11, verbatimTextOutput("completedSentence"))),
						 'Time (seconds) spent on prediction:',
						 fluidRow(column(5, verbatimTextOutput("tm"))),    
						 fluidRow(column(5, "Prediction from the trigram model:"), column(5, "Prediction from the bigram model:")),
                         fluidRow(column(5, verbatimTextOutput("w3")),column(6, verbatimTextOutput("w2"))),    
                         h3('Model info'),
						 fluidRow(column(5, "Top candiates from the trigram model:"), column(5, "Top candiates from the bigram model:")),
                         fluidRow(column(5, verbatimTextOutput("nlpModelInfo.3")), column(5, verbatimTextOutput("nlpModelInfo.2")))
				 		 ),
                tabPanel("Documentation",
						 h3(""),
						 'The Natural Language Processind model based on tri- and bigrams genereated from 150,000 and 60,000 randomly 
					      selected lines from the en_US.twitter.txt and en_US.news.txt data files.',  
				 		 h3(""),
						 'It takes about 30-40 seconds to load the model. Please be patient to be able to start using the app.',
						 h3(""),
						 'Back off model is used for prediction: ', 
						 HTML('<UL>
						 		<LI>Trigram prediction is returned if it is not NA. 
						 		<LI>If Trigram prediciton is NA then Bigram prediction is returned if is not NA. 
						 		<LI>NA is returned if both the Tri and Bigram predictions are NA. 
								</UL>'),
						 'Time spent in prediction is displayed.',
						 h3(""),
					     'The following set of "stop" words are ignored in the model and therefore are never predicted if one of these word follows the typed sentecne in the input:',
                         fluidRow(column(11, verbatimTextOutput("stopwords")))
                         )
				 )
    		)
))


