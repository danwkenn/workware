args = commandArgs(trailingOnly=TRUE)

library(stringr)
file = args[[1]]
source = args[[2]]
new_list <- read.csv(file,stringsAsFactors = FALSE)

if(source == "exportify"){
  colnames(new_list)[[1]] <- "url"
  new_list$played <- FALSE
  new_list$stub <- str_match(new_list$url,pattern = "^spotify:track:(.*)$")[,2]
  new_list$stub[is.na(new_list$stub)] <- new_list$url
  new_list$url <- paste0("https://open.spotify.com/track/",new_list$stub)
  new_list <- new_list[,c("url","played")]
}

write.csv(new_list,row.names = FALSE,file = "song-list.csv")
cat("Import complete.\n")