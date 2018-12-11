# Set the Working Directory where you want to store the scraped articles to.
# Try running the code line by line for better understanding

# Neseccasry Libraries

library(rvest)
library(RCurl)
library(XML)


# Defining the search Term
term = "gold"
term = gsub(" ", "-", term, fixed = TRUE)

# Creating the base adddress/home page for scraping
base_addr = paste0("https://www.moneycontrol.com/news/tags/",term,".html")

# Extracting HTML of the page we want to scrape from 
page <- read_html(base_addr)

# Finding the last page of available data
last = tail(page %>% html_nodes('div.pagenation') %>% html_nodes('a') %>% html_attr('data-page'),1)

# Creating links for all pages to scrape from 
pages = matrix()
for(iter in 1:last){
  pages[iter] = paste0(base_addr,"/page-",iter,"/")
  
}

# Initialzing the dataframe that will hold the data
testData = data.frame()


# Scraping process

# Loop to iterate through pages Page 1, Page 2, ... , Page N
for (pageIterate in 1:last){
  
  
  # Link of every page from which we will scrape data
  page = read_html(pages[pageIterate])
  
  # Extracting all articles on the page
  allArticleNodes = page %>% html_nodes('ul') %>% html_nodes('li.clearfix')
  
  # Loop to iterate through articles on one page
  for(iterate in 1 : length(allArticleNodes)){
    
    # Creating rows of Information
    
    # rowInf will be a vector of the following format
    # | Link | Headlines | Date | Text |
    
    rowInf = c((allArticleNodes %>% html_nodes('h2') %>% html_nodes('a') %>% html_attr('href'))[iterate],
               (allArticleNodes %>% html_nodes('h2') %>% html_nodes('a') %>% html_attr('title'))[iterate],
               (allArticleNodes %>% html_nodes('span') %>% html_text())[iterate])
    
    # We will extract text only if a the link for the article exists
    if(url.exists(rowInf[1])==TRUE){
      
      # Reading HTML page
      explore <- read_html(rowInf[1])
      
      # Subheading and text of the news Article
      subHead = explore %>% html_nodes('article.article_box') %>%html_nodes('h2.subhead')%>% html_text()
      newsText =explore %>% html_nodes('article.article_box') %>%html_nodes('div.arti-flow') %>% html_nodes('p') %>% html_text()
      
      # Pasting Subheading and Text together
      text = paste(subHead,newsText,collapse=" ")
      
      # Appening the text to the rowInf
      rowInf <- append(rowInf,text)
      
    }
    
    # In case the text doesnt exist, NA is added
    length(rowInf) <- 4
    
    # Adding data to dataFrame
    newData = rbind(newData2,t(as.matrix(rowInf)))
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
write.csv(testData, "moneyControlData.csv",row.names = FALSE)

