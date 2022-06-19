
library(tidyr)
library(dplyr)
library(magrittr)
library(stringr)
library(rvest)
library(readr)

getDATA <- function(html){
  html %>%
    html_nodes(".allText") %>%
    html_text() %>%
    str_trim() %>%
    unlist()
  
}


suppressMessages(IMDBdata <- read_csv("C:/Users/kilbi/Documents/IMDB/IMDBcode.csv")
)


CODES <- IMDBdata %>% pull(IMDBCode)

MASTERDATA <- data.frame()


for(i in 1:length(CODES)){

IMDBCode <- CODES[i]

THISURL <- paste0("http://www.imdb.com/title/",IMDBCode,"/ratings/")
myURL <- read_html(THISURL)


df_html <- getDATA(myURL)
df_html <- data.frame(matrix(df_html[3:32],ncol=3,byrow=TRUE) )
df_html <- data.frame(IMDBCode,DATE=Sys.Date(),df_html)
df_html <- df_html %>% mutate(X3=gsub(",","",X3),X3=as.numeric(X3))

MASTERDATA <- MASTERDATA %>% bind_rows(df_html)

}

MASTERDATA  %>% write.csv(paste0("C:/Users/kilbi/Documents/IMDB/Ratings-Breakdown-Data-",Sys.Date(),".csv"),row.names = FALSE)
