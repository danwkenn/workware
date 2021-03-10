cat("Paste in URL here:")
A <- readLines("stdin",n=1)

song_list <- read.csv("song-list.csv",stringsAsFactors = FALSE)

To_Delete = which(song_list$url == A)
if(length(To_Delete) == 0){
  cat("ERROR: Song not found.")
}else{
  song_list <- song_list[-To_Delete,]
}

write.csv(song_list,row.names = FALSE,file = "song-list.csv")
