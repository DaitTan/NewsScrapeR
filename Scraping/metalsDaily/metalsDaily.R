library("rvest")
library("RSelenium")

rd = rsDriver()

remDr <- rd$client

remDr$navigate("https://www.metalsdaily.com/news/gold-news/")
webElem <- remDr$findElement("css selector", "div#ntbl_14_1.newsTable.ns_NewsTable > div.newsPaging > a#pag1.page.selected")
webElem$clickElement()

for(i in 1:242){
  webElem <- remDr$findElement("css selector", paste0("div#ntbl_14_", i, ".newsTable.ns_NewsTable > div.newsPaging > a#pag", i+1,".page"))
  if(webElem$getElementText() == ".."){
    i=i-1
  }
  webElem$clickElement()
  webElem$setImplicitWaitTimeout(1000)
}

page <- read_html(remDr$getPageSource()[[1]])

articles = NULL
metalsDaily = data.frame()

for(i in  1:242){
  articles <- page %>% html_nodes(paste0("div#ntbl_14_", i, ".newsTable.ns_NewsTable")) %>% html_nodes('li')
  
  href <- articles %>%html_nodes('a') %>% html_attr('href')
  date <- articles %>%html_nodes('a') %>% html_nodes('span.Date') %>% html_text()
  news <- articles %>%html_nodes('a') %>% html_attr('title')
  pageArticles <- as.data.frame(cbind(date,href,news))
  
  metalsDaily <- rbind(metalsDaily,pageArticles)
  
  message(i)
}

metalsDaily$date <- as.Date(metalsDaily$date,format = "%d-%m-%y")

write.csv(metalsDaily, "metalsDaily.csv", row.names = FALSE)
