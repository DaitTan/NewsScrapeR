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

# Reading HTML of the home page for scraping
page <- read_html(paste0("https://economictimes.indiatimes.com/topic/",term))

# Base address for generating links for scraping
base_addr <- "https://economictimes.indiatimes.com"

# Links of all the pages to scrape
pageLinks = unique(page %>% html_nodes('noscript') %>% html_nodes('div#pagination') %>% html_nodes('a')%>%html_attr('href'))
pages = paste0(base_addr,pageLinks)

# Scraping process

# Loop to iterate through pages Page 1, Page 2, ... , Page N
for(pageIterate in 1:length(pages)){
  
  # reading the HTMl of page
  content <- read_html(pages[pageIterate])
  
  # Digging the sections for articles along with other attributes
  secs <- content%>%html_nodes('ul.data')%>%html_nodes('li#all.active')%>%html_nodes('div')
  
  # Loop to iterate through articles on one page
  for(iterate in 1:length(secs)){
    
    # Creating rows of Information
    
    # rowInf will be a vector of the following format
    # | Link | Headlines | Date | Text |
    
    rowInf <- c(paste0(base_addr,secs[[iterate]]%>%html_nodes('a')%>% html_attr('href')), 
                secs[[iterate]]%>%html_nodes('a')%>% html_nodes('h3') %>% html_text(),
                secs[[iterate]]%>% html_nodes('time') %>% html_text())
    
    # We will extract text only if a the link for the article exists
    if(url.exists(rowInf[1])==TRUE){
      
      # Reading HTML page
      explore <- read_html(rowInf[1])
      
      # Scraping the news text
      text = html_nodes(explore,'div') %>%html_nodes('.Normal')%>% html_text()
      
      # Appening the text to rowInformation
      rowInf <- append(rowInf, text)
    }
    
    # In case the text doesnt exist, NA is added
    length(rowInf) <- 4
    
    # Adding data to dataFrame
    data = rbind(data,t(as.matrix(rowInf)))
    message("Article ", iterate)
    
    # Resetting the rowInf for next article
    rowInf=NULL
  }
  message("Page ", pageIterate)
  message("*********** ", pageIterate)
  message("*********** ", pageIterate)
  message("*********** ", pageIterate)
}


# Renaming columns of the dataFrame
colnames(data) <- c("link", "headlines", "timeStamp", "text")

# Saving DataFrame

write.csv(data, "ETData.csv",row.names = FALSE)

