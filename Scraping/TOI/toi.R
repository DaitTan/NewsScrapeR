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

# Creating the home page for scraping and extracting HTML
page <- read_html(paste0("https://timesofindia.indiatimes.com/topic/",term))

# This is the base address of every page for TOI pages
base_addr <- "https://timesofindia.indiatimes.com"

# Creating links for all pages to scrape from 
pages = paste0(base_addr,
               html_nodes(page, '.tab_content')%>% html_nodes('a.look') %>% html_attr('href'))

# Initialzing the dataframe that will hold the data			   
testData = data.frame()

# Scraping process

# Loop to iterate through pages Page 1, Page 2, ... , Page N
for(pageIterate in 1:length(pages)){
  
  # HTML of page from which we will scrape data
  content <- read_html(pages[pageIterate])
  
  # Extracting all articles on the page
  secs <-html_nodes(content, '.tab_content')%>% html_nodes('li')%>% html_nodes('div')%>% html_nodes('a')
  
  # Identifying if the news is from the Any ______Mirror
  paperSite <- c("bangaloremirror","mumbaimirror","punemirror")
  
  # Loop to iterate through articles on one page
  for(iterate in 1:length(secs)){
    
    # Creating rows of Information
    
    # rowInf will be a vector of the following format
    # | Link | Headlines | Date | Text |
    
    rowInf <- c(paste0(base_addr,secs[[iterate]]%>% html_attr('href')), 
                secs[[iterate]]%>% html_nodes('span.title') %>% html_text(),
                secs[[iterate]]%>% html_nodes('span.meta') %>% html_text())
    
    # Move to site if the site exists.
    if(url.exists(rowInf[1])==TRUE){
      
      # Reading HTML page
      explore <- read_html(rowInf[1])
      # Text of the News Article
      text = html_nodes(explore,'div') %>%html_nodes('.Normal')%>% html_text()
      
      # Appening the text to the rowInf
      rowInf <- append(rowInf, text)
      
    }
    
    # In case the text doesnt exist, NA is added
    length(rowInf) <- 4
    
    # Adding data to dataFrame
    testData = rbind(testData,t(as.matrix(rowInf)))
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
colnames(testData) <- c("link", "headlines", "timeStamp", "text")

# Saving DataFrame

#write.csv(testData, "TOIData.csv",row.names = FALSE)

