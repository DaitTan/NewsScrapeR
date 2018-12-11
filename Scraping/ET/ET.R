#unlink("D:/dataTestET", recursive = TRUE)

library(rvest)
library(RCurl)
library(XML)
data<-data.frame()
term = "gold commodity"
term = gsub(" ", "-", term, fixed = TRUE)
page <- read_html(paste0("https://economictimes.indiatimes.com/topic/",term))
base_addr <- "https://economictimes.indiatimes.com"
t = unique(page %>% html_nodes('noscript') %>% html_nodes('div#pagination') %>% html_nodes('a')%>%html_attr('href'))
pages = paste0(base_addr,t)
               
temp = page%>%html_nodes('ul.data')%>%html_nodes('li#all.active')%>%html_nodes('div')
time = temp%>%html_nodes('time')%>%html_text()
dir.create(file.path("D:/", "dataTestET"), showWarnings = FALSE)
setwd(file.path("D:/", "dataTestET"))

for(pageIndex in 1:length(pages)){
  wdName = paste0("dataTestET",pageIndex)
  dir.create(file.path("D:/dataTestET", wdName), showWarnings = FALSE)
  setwd(file.path("D:/dataTestET", wdName))
  content <- read_html(pages[pageIndex])
  secs <- content%>%html_nodes('ul.data')%>%html_nodes('li#all.active')%>%html_nodes('div')
  lengthData = length(secs%>% html_attr('href'))
  for(a in 1:lengthData){
    rowInf <- c(paste0(base_addr,secs[[a]]%>%html_nodes('a')%>% html_attr('href')), 
                secs[[a]]%>%html_nodes('a')%>% html_nodes('h3') %>% html_text(),
                secs[[a]]%>% html_nodes('time') %>% html_text())
    
    if(url.exists(rowInf[1])==TRUE){
      
      
      explore <- read_html(rowInf[1])
      
      text = html_nodes(explore,'div') %>%html_nodes('.Normal')%>% html_text()
      
      
      rowInf <- append(rowInf, text)
    }
    
    # Saving to text file
    fileName = paste0("news",a,".txt")
    write.table(rowInf,file=fileName,row.names=FALSE)
    rowInf = NULL
    paste("news" , a , "saved")
  }
  

}




