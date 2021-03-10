# wait_with_progress_bar <- function(time_length, n_updates = 50){
#   #Convert minutes to seconds:
#   time_length = time_length * 60
#   time_incr = time_length / n_updates
#   count = 0
#   txt = txtProgressBar(min = 0,max = n_updates,style = 3)
#   for(i in 1:n_updates){
#     Sys.sleep(time_incr)
#     setTxtProgressBar(txt,i)
#   }
# }

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
  wait_with_progress_bar <- function(time_length, window_width = 80, n_updates = 50){
    #Convert minutes to seconds:
    time_length = round(time_length * 60)
    if(time_length!=0){
    system(paste0("functions/pausable_timer.exe ",time_length))
    }
  }
}
