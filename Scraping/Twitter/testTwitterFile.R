#install.packages("twitteR")
library(twitteR)
library(streamR)
library(ROAuth)
library(rtweet)
library(tm)
library(wordcloud)
library(tidytext)
library(tibble)
library(dplyr)
library(stringr)
library(ggplot2)
# create_token(
#   consumer_key = "PupDb0PLULKEz1J9W1L8rUbvz",
#   consumer_secret = "KfYJauivqkHx9EmEEnKkfuZWaTY3FrPUWNlbKLN1pgqanzrniT",
#   access_token = "1070760415934636033-KiChn7fxWO8sDOwBPZl7KDnSPWmVbY",
#   access_secret = "VoMhYOeoBQe8UlWanHOAOlWFaNZZtSDMFVFGiBRRmeOqT"
# )
# tw = search_tweets("GOLD", n=25, lang = "en")


create_token(
  consumer_key = "AQM9YXNZsrRXrANQjgZf5FpMz",
  consumer_secret = "1ITuLcrxSOD5k9IPRVqcgDkvRPMjTelKmFdElsLNCowhPCEF5O",
  access_token = "760324750828638208-xbg3oepcN7rDUpKyi9KyDkaowpzumg7",
  access_secret = "vhu81WQJ0w8t2nnnPtJxSueJK9LWsn7SeVn7czuWYIKmA"
)

tweets = search_tweets("#Results2018", n=1000, lang = "en")

tweet.text<- tweets$text

#convert all text to lower case
tweet.text <- tolower(tweet.text)

# Replace blank space (“rt”)
tweet.text <- stripWhitespace(tweet.text)

# Remove blank space at starting
tweet.text <- gsub("(^\s+)","",tweet.text)

# remove blank space at ending
tweet.text <- gsub("((\\s+)$)","", tweet.text)

# Replace @UserName
tweet.text <- gsub("@\\w+", "", tweet.text)

# Remove Punctuation
tweet.text <- gsub("[[:punct:]]","",tweet.text)

# Removing Links
tweet.text <- gsub("((http|https)\\w*)", "", tweet.text)

# Removing Stop Words
tweet.text.corpus <- removeWords(tweet.text,stopwords())


tidyText = data_frame(line = 1:length(tweet.text), text= tweet.text.corpus)
tidyTokens <- tidyText %>% unnest_tokens(word,text)
tidyTokens <- tidyTokens %>% count(word,sort = TRUE)



