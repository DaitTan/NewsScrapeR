#install.packages("rvest")
#install.packages("RSelenium")

library(rvest)
library(RSelenium)

rd <- rsDriver()

remDr <- rd$client

remDr$getStatus()

remDr$navigate("https://www.investing.com/search/?q=gold&tab=news")

webElem <- remDr$findElement(using="css selector",".popupCloseIcon.largeBannerCloser")
webElem$clickElement()
webElem <- remDr$findElement(using = "css selector", ".dateField.inlineblock")
webElem$clickElement()
webElem <- remDr$findElement(using = "css selector", "#startDate")
webElem$sendKeysToElement(list("\uE003","\uE003","\uE003","\uE003","\uE003","\uE003","\uE003","\uE003","01/01/1999"))
webElem <- remDr$findElement(using = "css selector", "#endDate")
webElem$sendKeysToElement(list("\uE003","\uE003","\uE003","\uE003","\uE003","\uE003","\uE003","\uE003","12/25/18",key = "enter"))

webElem <- remDr$findElement(using="css","ul.checkboxList > li > label > [data-value='11']")
webElem$clickElement()

webElem <- remDr$findElement(using="css","ul.checkboxList > li > label > [data-value='1']")
webElem$clickElement()


webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))
webElem$sendKeysToElement(list(key = "home"))

page <- read_html(webElem$getPageSource()[[1]])

articles <- page %>% html_nodes('div.articleItem')

date <- articles %>% html_nodes('div.textDiv') %>% html_nodes('div.articleDetails') %>% html_nodes('time') %>% html_text()
href<- articles %>% html_nodes('a.title') %>% html_attr('href')
text <- articles %>% html_nodes('div.textDiv') %>% html_nodes('a') %>% html_text()

href <- paste0("http://www.investing.com",href)

investing <- as.data.frame(cbind(href, date, text))
remDr$close()
rd$server$stop()
