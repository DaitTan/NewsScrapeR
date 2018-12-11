# Set the Working Directory where you want to store the scraped articles to.
# Try running the code line by line for better understanding

# Neseccasry Libraries

library(rvest)
library(RCurl)
library(XML)

data<-data.frame()

# Defining the search Term
term = "gold"
term = gsub(" ", "-", term, fixed = TRUE)

base_addr = paste0("https://www.moneycontrol.com/news/tags/",term,".html")
# Page we want to scrape from 
page <- read_html(base_addr)

last = tail(page %>% html_nodes('div.pagenation') %>% html_nodes('a') %>% html_attr('data-page'),1)
pages = matrix()
for(iter in 1:last){
  pages[iter] = paste0(base_addr,"/page-",iter,"/")
  
}


# FOlder where all scraped data will be stored
dir.create(file.path("D:/IGPC/NewsScraper", "MoneyControl"), showWarnings = FALSE)
setwd(file.path("D:/IGPC/NewsScraper", "MoneyControl"))

for (pageIterate in 98:last){
  wdName = paste0("MoneyControl",pageIterate)
  dir.create(file.path("D:/IGPC/NewsScraper/MoneyControl", wdName), showWarnings = FALSE)
  setwd(file.path("D:/IGPC/NewsScraper/MoneyControl", wdName))
  
  
  # Link of every page from which we will scrape data
  
  page = read_html(pages[pageIterate])
  
  allArticleNodes = page %>% html_nodes('ul') %>% html_nodes('li.clearfix')
  
  for(iterate in 1 : length(allArticleNodes)){
    rowInf = c((allArticleNodes %>% html_nodes('h2') %>% html_nodes('a') %>% html_attr('href'))[iterate],
               (allArticleNodes %>% html_nodes('h2') %>% html_nodes('a') %>% html_attr('title'))[iterate],
               (allArticleNodes %>% html_nodes('span') %>% html_text())[iterate])
    
    if(url.exists(rowInf[1])==TRUE){
      
      
      explore <- read_html(rowInf[1])
      
      subHead = explore %>% html_nodes('article.article_box') %>%html_nodes('h2.subhead')%>% html_text()
      
      text =explore %>% html_nodes('article.article_box') %>%html_nodes('div.arti-flow') %>% html_nodes('p') %>% html_text()
      
      rowInf <- append(append(rowInf, subHead),text)
      
    }
    
    fileName = paste0("MoneyControlNews",iterate,".txt")
    write.table(rowInf,file=fileName,row.names=FALSE)
    rowInf = NULL
    paste("news" , iterate , "saved")
  }
}
