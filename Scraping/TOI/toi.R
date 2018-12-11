# Set the Working Directory where you want to store the scraped articles to.
# Try running the code line by line for better understanding

# Neseccasry Libraries

library(rvest)
library(RCurl)
library(XML)

data<-data.frame()

# Defining the search Term
term = "gold commodity"
term = gsub(" ", "-", term, fixed = TRUE)


# Page we want to scrape from 
page <- read_html(paste0("https://timesofindia.indiatimes.com/topic/",term))

# This is the base address of every url for TOI
base_addr <- "https://timesofindia.indiatimes.com"

# Link of every page from which we will scrape data
pages = paste0(base_addr,
               html_nodes(page, '.tab_content')%>% html_nodes('a.look') %>% html_attr('href'))

# FOlder where all scraped data will be stored
dir.create(file.path("D:/IGPC/NewsScraper", "dataTest"), showWarnings = FALSE)
setwd(file.path("D:/IGPC/NewsScraper", "dataTest"))

# Looping through
for(pageIndex in 1:length(pages)){
  # Setting up directory for every page
  wdName = paste0("dataTest",pageIndex)
  dir.create(file.path("D:/IGPC/NewsScraper/dataTest", wdName), showWarnings = FALSE)
  setwd(file.path("D:/IGPC/NewsScraper/dataTest", wdName))
  
  # Read content from pages
  content <- read_html(pages[pageIndex])
  
  # List of articles on a page
  secs <-html_nodes(content, '.tab_content')%>% html_nodes('li')%>% html_nodes('div')%>% html_nodes('a')
  
  # Identifying if the news is from the Any ______Mirror
  paperSite <- c("bangaloremirror","mumbaimirror","punemirror")
  
  
  lengthData = length(secs%>% html_attr('href'))
  
  for(a in 1:lengthData){
    rowInf <- c(paste0(base_addr,secs[[a]]%>% html_attr('href')), 
                secs[[a]]%>% html_nodes('span.title') %>% html_text(),
                secs[[a]]%>% html_nodes('span.meta') %>% html_text())
    
    # Move to site if the site exists.
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
