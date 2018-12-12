#install.packages("twitteR")
library(twitteR)
library(streamR)
library(ROAuth)
library(rtweet)

create_token(
  consumer_key = "PupDb0PLULKEz1J9W1L8rUbvz",
  consumer_secret = "KfYJauivqkHx9EmEEnKkfuZWaTY3FrPUWNlbKLN1pgqanzrniT",
  access_token = "1070760415934636033-KiChn7fxWO8sDOwBPZl7KDnSPWmVbY",
  access_secret = "VoMhYOeoBQe8UlWanHOAOlWFaNZZtSDMFVFGiBRRmeOqT"
)



tw = search_tweets("GOLD", n=25, lang = "en")





  

