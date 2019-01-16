library("rvest")
library(rvest)
library(RCurl)
library(XML)
library(httr)
library("RSelenium")

rd = rsDriver()

remDr <- rd$client
mw = read.csv("marketWatch.csv")

urls <- as.character(mw$URL)
cont = (matrix(NA,nrow = 29865,ncol = 1))

for(pageIterate in 1:29865){
  message("*********** ", pageIterate)
  message(pageIterate, " started")
  s = http_status(GET(urls[pageIterate]))
  message(s$category)
  if(s$category == "Success"){
    page = read_html(urls[pageIterate])
    text = page %>% html_nodes("div#article-meat") %>% html_nodes("div#article-body")%>%html_text()
  } else{
    text = s$reason
  }
  if(length(text) == 0 || is.na(text)){
    text = "NO Data"
  }
  cont[pageIterate] = text
  text = NA
  message(pageIterate, " ended")
  message("***********")
}

# script for catching error

for(pageIterate in 1:29865){
  tryCatch({
    message(pageIterate)
    s = http_status(GET(urls[pageIterate]))
    if(s$category == "Success"){
      page = read_html(urls[pageIterate])
      text = page %>% html_nodes("div#article-meat") %>% html_nodes("div#article-body")%>%html_text()
    } else{
      text = s$reason
    }
    if(length(text) == 0 || is.na(text)){
      text = "NO Data"
    }
    cont[pageIterate] = text
    text = NA
  },error=function(e){
    cat("ERROR :",pageIterate, " : ",conditionMessage(e), "\n")
  })
}




