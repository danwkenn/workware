args = commandArgs(trailingOnly=TRUE)

a <- pkgbuild::find_rtools()

# Set browser:
OS <- Sys.info()["sysname"]
if(OS == "Linux"){
  con_output <- (system("type google-chrome-stable",intern = TRUE))
  browser <- stringr::str_match_all(con_output,pattern = "^google-chrome-stable is (.*?)$")[[1]][1,2]
}else{
  browser = NULL
}

if(length(args) == 0){
  cat("Do you want an initial 10 minute thinking session? (Y/N)")
  INITIAL <- as.character(unlist(readLines("stdin",n=1)))
  while(!(INITIAL %in% c("Y","N"))){
    cat("Do you want an initial 10 minute thinking session? (Y/N)")
    INITIAL <- as.character(unlist(readLines("stdin",n=1)))
  }
  INITIAL <- INITIAL == "Y"
  if(INITIAL){
  cat("How long would you like to think for? (mins)")
    thinking_time = as.numeric(unlist(readLines("stdin",n=1)))
  while(is.na(thinking_time)){
    cat("How long would you like to think for? (mins)")
    thinking_time = as.numeric(unlist(readLines("stdin",n=1)))
  }
  }else{
    thinking_time = 0
  }
}else{
  thinking_time = as.numeric(args[[1]])
}

# Ask if song or meditate:
cat("In breaks do you want to listen to songs (1) or meditate (2)?")
response <- as.character(unlist(readLines("stdin",n=1)))
while(!(response %in% c("1","2","songs","meditate"))){
  cat("Answer not accepted.\nIn breaks do you want to listen to songs (1) or meditate (2)?")
  response <- as.character(unlist(readLines("stdin",n=1)))
}
if(response %in% c("2","meditate")){
  
  break_type <- "meditate"
  
}else{

# Ask if random or not:
cat("Pick the next song randomly (T) or in order (F)?")
RANDOM <- as.character(unlist(readLines("stdin",n=1)))
while(!(RANDOM %in% c("T","F"))){
  cat("Answer not accepted.\nPick the next song randomly (T) or in order (F)?")
  RANDOM <- as.character(unlist(readLines("stdin",n=1)))
}
RANDOM <- as.logical(RANDOM)

  break_type <- "song"

}

# Timer function:
OS <- Sys.info()["sysname"]
if(OS == "Linux"){
  cat("Compiling timer C++ function...\n")
  library(Rcpp)
  Rcpp::sourceCpp("functions/pausable-timer-linux.cpp")
  wait_with_progress_bar <- function(time_length, window_width = 80){
    #Convert minutes to seconds:
    time_length = round(time_length * 60)
    if(time_length!=0){
      command_line_timer(time_length,window_width)
    }
  }
}else{
  # Use precompiled executable:
  wait_with_progress_bar <- function(time_length, window_width = 80, n_updates = 50){
    #Convert minutes to seconds:
    time_length = round(time_length * 60)
    if(time_length!=0){
      system(paste0("functions/pausable_timer.exe ",time_length))
    }
  }
}

source("functions/wait_with_progress_bar.R")
window_width = options("width")$width - 10

#Thinking time
if(thinking_time != 0){
  sink(file = "log.txt",append = TRUE)
  cat("thinking time start",",",as.character(Sys.time()),sep = "")
  sink(file = NULL)
  cat("Beginning ",round(thinking_time,2)," minutes of thinking time.\n")
  wait_with_progress_bar(thinking_time,window_width)
  sink(file = "log.txt",append = TRUE)
  cat("thinking time complete",",",as.character(Sys.time()),sep = "")
  sink(file = NULL)
  cat("Initial thinking time complete.")
}

#Pomodoro time management cycle.
work_times <- unlist(suppressWarnings(read.csv("interval-lengths.csv",header = FALSE)))
break_times <- rep(3.5,length(work_times))

cat("Beginning pomodoro session...\n")
cat("Total length: ",sum(work_times) + sum(break_times), "minutes\n")

for(i in 1:length(work_times)){
  #Do a break
  source("functions/play_next_song.R")
  sink(file = "log.txt",append = TRUE)
  cat("break start",",",as.character(Sys.time()),sep = "")
  sink(file = NULL)
  wait_with_progress_bar(break_times[i],window_width)
  sink(file = "log.txt",append = TRUE)
  cat("break end",",",as.character(Sys.time()),sep = "")
  sink(file = NULL)
  
  browseURL("https://youtu.be/263e093H5eM",browser = browser)
  
  message(paste0("What are you doing for this work session? ",work_times[i]," minutes\n"))
  purpose <- readLines("stdin",n=1)
  cat("\033[0;36mSelf-assigned task: \033[0m",purpose)
  
  cat(paste0("\nBeginning interval ",i," of ",length(work_times),". Length: ",work_times[i]," minutes\n"))
  #Do a work
  sink(file = "log.txt",append = TRUE)
  cat("work interval start",",",as.character(Sys.time()),sep = "")
  sink(file = NULL)
  wait_with_progress_bar(work_times[i],window_width)
  sink(file = "log.txt",append = TRUE)
  cat("work interval end",",",as.character(Sys.time()),sep = "")
  sink(file = NULL)
}
cat("\nPomodoro session complete.\n")
source("functions/play_next_song.R")
write.csv(song_list,row.names = FALSE,file = "song-list.csv")
