library(rvest)
library(stringr)


page <- read_html("https://www.marketwatch.com/search?q=Gold&m=Keyword&rpp=100&mp=806&bd=false&rs=true")
articles <- page %>% html_nodes('div.block')
date <- articles %>% html_nodes('div.deemphasized') %>% html_nodes('span') %>% html_text()
href <- articles %>% html_nodes('div.searchresult') %>% html_nodes('a') %>% html_attr('href')
news <- articles %>% html_nodes('div.searchresult') %>% html_nodes('a') %>% html_text()
marketsWatch <- as.data.frame(cbind(date,href,news))

for(i in 1:670){
  page <- read_html(paste0("https://www.marketwatch.com/search?q=Gold&m=Keyword&rpp=100&mp=806&bd=false&rs=true&o=", i,"01"))
  articles <- page %>% html_nodes('div.block')
  date <- articles %>% html_nodes('div.deemphasized') %>% html_nodes('span') %>% html_text()
  href <- articles %>% html_nodes('div.searchresult') %>% html_nodes('a') %>% html_attr('href')
  news <- articles %>% html_nodes('div.searchresult') %>% html_nodes('a') %>% html_text()
  
  marketsWatch <- rbind(marketsWatch, as.data.frame(cbind(date,href,news)))
  message("Page: ", i ," Count= ", length(date))
  date = NULL
  href = NULL
  news = NULL
  
  
}

write.csv(marketsWatch,"marketsWatch.csv",row.names = FALSE)
  