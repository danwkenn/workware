cat("Paste in URL here:")
A <- readLines("stdin",n=1)

song_list <- read.csv("song-list.csv",stringsAsFactors = FALSE)
song_list[nrow(song_list) + 1,] = 
  list(A,FALSE)

write.csv(song_list,row.names = FALSE,file = "song-list.csv")
