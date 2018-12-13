setwd(file.path("D:/NNHD-20181212T083606Z-001/NNHD"))
df = data.frame()
year = NULL
month = NULL
day = NULL

year = seq(2006,2017)
month = seq(1:12)
day = seq(1:31)

links = NULL

#links = paste0("D:\NNHD-20181212T083606Z-001\NNHD\" , year,"\\", month, "_", year, "\\", year, "_",month,"_",day)
for(iterateYear in year){
  for(iterateMonth in month){
    for(iterateDay in day){
      link = paste0(iterateYear,"/", iterateMonth, "_", iterateYear, "/", iterateYear, "_",iterateMonth,"_",iterateDay,".csv")
      df = rbind(df,as.matrix(link))
      link = NULL
    }
  }
}

data2 = data.frame()
for(iterate in 2592:4464){
  if (file.exists(as.character(df[iterate,1]))){
    data2 = rbind(data2,read.csv(as.character(df[iterate,1])))
    message(iterate)
  }
}


newData=data.frame()
newData = rbind(data,data2)
write.csv(newData,"ETData.csv",row.names = FALSE)
newData$Title = tolower(newData$Title)
df_gold = newData[which((str_detect(newData$Title, "gold"))),]
write.csv(df_gold, "GoldDataET.csv", row.names = FALSE)
