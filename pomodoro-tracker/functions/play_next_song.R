if(break_type == "meditate"){
  
  # Randomly sample a mediatation track:
  meditation_tracks <- c("https://youtu.be/SEfs5TJZ6Nk",
  "https://youtu.be/iebciuBXCh4",
  "https://youtu.be/ODhEvxSZlxI")
  browseURL(sample(meditation_tracks,1),browser = browser)
  
  
}else{

#play_next_song
song_list <- read.csv("song-list.csv",stringsAsFactors = FALSE)

#If all played
if(all(song_list$played)){
  #Reset:
  song_list$played <- FALSE
}

if(RANDOM){
  next_song_num <- sample(size = 1, x = which(!song_list$played))
}else{
  next_song_num <- min(which(!song_list$played))
}

browseURL(song_list$url[next_song_num],browser = browser)
song_list$played[next_song_num] <- TRUE

write.csv(song_list,row.names = FALSE,file = "song-list.csv")
}