CleanDocument <- function(ptextDoc, bPrint = FALSE, bRemoveStopWords = TRUE) {
  # Replace any sequence of characters 3 or longer with one instance of the character    
  # http://stackoverflow.com/questions/19943564/regex-how-to-match-sequence-of-same-characters    
  text <- gsub("(([a-z,A-Z])\\2{3,})", "\\2", as.character(ptextDoc), perl=TRUE)     
  if (bPrint) {
    print("remove repeated characters")
    print(text)
  }  
  
  # Remove words shorter then 3 characters
  text <- gsub("\\b[a-zA-Z0-9]{1,2}\\b", "", as.character(ptextDoc))
  if (bPrint) {
    print("remove word shorter than 3 characters")
    print(text)
  }   
  
  # Switching back to text doc
  ptextDoc <- PlainTextDocument(text, language="en")  
  
  # Switching back to text doc
  ptextDoc <- PlainTextDocument(text, language="en")  
  
  ptextDoc <- stripWhitespace(ptextDoc)
  if (bPrint) {
    print("stripWhitespace")
    print(ptextDoc)
  }
  ptextDoc <- removeNonASCII(ptextDoc) 
  if (bPrint) {
    print("removeNonASCII")    
    print(ptextDoc)
  }    
  ptextDoc <- removeNumbers(ptextDoc) 
  if (bPrint) {
    print("removeNumbers")    
    print(ptextDoc)
  }  
  ptextDoc <- removePunctuation(ptextDoc)     
  if (bPrint) {
    print("removePunctuation")    
    print(ptextDoc)
  }  
  # Remove stop words first because removePunction probably
  # converts you'll to youll and you'll is a stop word and
  # needs to be revomed
  if (bRemoveStopWords) {
    ptextDoc <- remove_stopwords(tokenize(as.character(ptextDoc)),stopwords("en"))
    ptextDoc <- paste(ptextDoc, collapse="")    
    ptextDoc <- PlainTextDocument(ptextDoc, language="en")    
    if (bPrint) {
      print("remove_stopwords")    
      print(ptextDoc)
    }     
  }   
  ptextDoc <- stripWhitespace(ptextDoc)  
  if (bPrint) {
    print("stripWhitespace")    
    print(ptextDoc)
  }
  ptextDoc <- PlainTextDocument(tolower(as.character(ptextDoc)), language="en")
  if (bPrint) {
    print("tolower")
    print(ptextDoc)
  }    
  # From here we are dealing with the text string "text"
  # http://stackoverflow.com/questions/19943564/regex-how-to-match-sequence-of-same-characters       
  # Replace any sequence of characters longer then 2 with one instance of the character    
  text <- gsub("(([a-z,A-Z])\\2{2,})", "\\2", as.character(ptextDoc), perl=TRUE)    
  if (bPrint) {
    print("repeated characters")
    print(text)
  }   
  # Switching back to text doc
  ptextDoc <- PlainTextDocument(text, language="en")  
}

Predict.3 <- function(text,dt.3) {
  text.cleaned <- as.character(CleanDocument(PlainTextDocument(text, language = "en")))
  
  text.vector <- ngram_tokenizer(1)(text.cleaned)
  len <- length(text.vector)

  test.3(text.vector[len-1], text.vector[len],dt.3)
}

Predict.2 <- function(text,dt.2) {
  text.cleaned <- as.character(CleanDocument(PlainTextDocument(text, language = "en")))
  
  text.vector <- ngram_tokenizer(1)(text.cleaned)
  len <- length(text.vector)
  
  test.2(text.vector[len],dt.2)
}

test.3 <- function(term1,term2,dt.3) {
  dt.pred <- dt.3[dt.3$name3 == term1]
  dt.pred <- dt.pred[dt.pred$name2 == term2]
  dt.pred <- dt.pred[order(dt.pred$c321,decreasing=TRUE)]
  num.data <- dim(dt.pred)[1]
  if(num.data > 0) {
    prediction <- dt.pred[1,name1]
    dt.pred <- dt.pred[order(dt.pred$c321,decreasing=TRUE)]       
  } else {
    prediction <- NA
    dt.pred <- NA
  }
  list("dt.pred" = dt.pred, "prediction" = prediction)
}

test.2 <- function(term1,dt.2) {
  dt.pred <- dt.2[dt.2$name2 == term1]
  dt.pred <- dt.pred[order(dt.pred$c21,decreasing=TRUE)]
  num.data <- dim(dt.pred)[1]
  if(num.data > 0) {
    prediction <- dt.pred[1,name1]
    dt.pred <- dt.pred[order(dt.pred$c21,decreasing=TRUE)]   
  } else {
    prediction <- NA
  }
  list("dt.pred" = dt.pred, "prediction" = prediction)
}

