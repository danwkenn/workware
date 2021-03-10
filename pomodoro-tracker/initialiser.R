#Initialise:

song_list <- data.frame(
  url = character(),
  played = logical()
)

write.csv(song_list,row.names = FALSE,file = "song-list.csv")