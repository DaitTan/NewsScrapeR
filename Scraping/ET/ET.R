#unlink("D:/dataTestET", recursive = TRUE)

library(rvest)
library(RCurl)
library(XML)


data<-data.frame()

term = "gold commodity"
term = gsub(" ", "-", term, fixed = TRUE)
page <- read_html(paste0("https://economictimes.indiatimes.com/topic/",term))

base_addr <- "https://economictimes.indiatimes.com"

pageLinks = unique(page %>% html_nodes('noscript') %>% html_nodes('div#pagination') %>% html_nodes('a')%>%html_attr('href'))
pages = paste0(base_addr,pageLinks)

temp = page%>%html_nodes('ul.data')%>%html_nodes('li#all.active')%>%html_nodes('div')
time = temp%>%html_nodes('time')%>%html_text()



for(pageIndex in 1:length(pages)){
  
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
    
    length(rowInf)<-4
    data = rbind(data,t(as.matrix(rowInf)))
    message("Article ", a)
    rowInf = NULL
  }
  message("Page ", pageIndex)
  message("************ ", pageIndex)
  message("************ ", pageIndex)
  message("************ ", pageIndex)
}

colnames(data) <- c("link", "headlines", "timeStamp","text")

write.csv(data, "ETData.csv", row.names = FALSE)


