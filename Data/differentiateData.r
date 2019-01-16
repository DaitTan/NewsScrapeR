library('stringr')

data = read.csv('Data//data.csv')
sites = substr(data$URL,13,24)
unique(sites)
t = which(sites == "arketwatch.c")
marketWatch = data[t,]

t = which(sites == "metalsdaily.")
metalsDaily = data[t,]

t = which(sites == "nvesting.com")
investing = data[t,]

t = which(sites == "omictimes.in")
et = data[t,]

t = which(sites == "moneycontrol")
moneycontrol = data[t,]

write.csv(et,"et.csv",row.names = FALSE)
write.csv(investing,"investing.csv",row.names = FALSE)
write.csv(marketWatch,"marketWatch.csv",row.names = FALSE)
write.csv(metalsDaily,"metalsDaily.csv",row.names = FALSE)
write.csv(moneycontrol,"moneycontrol.csv",row.names = FALSE)

