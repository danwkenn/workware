calc_times <- function(work_times){
  thinking_time <- 0
  other_time <- 0
  break_times <- rep(3.5,length(work_times))
  tot_length = sum(work_times) + sum(break_times) + thinking_time + other_time
  cat("Pomodoro session Details:\n")
  cat("Total length: ",tot_length, "minutes\n")
  cat("Thinking time: ",thinking_time, "minutes\n")
  cat("Other time: ",other_time," minutes\n")
  cat("Work times (minutes):\n")
  cat(work_times,"\n")
  cat("Break times (minutes):\n")
  cat(break_times,"\n")
  cat("Estimated completion time:\n")
  cat(format(Sys.time() + tot_length * 60),"\n")
}

work_times <- c()
cat("Enter interval length in minutes, or enter \"DONE\":\n")
input <- readLines("stdin",n=1)
work_times <- c(work_times,as.numeric(input))
calc_times(work_times)

COMPLETE = FALSE
while(!COMPLETE){

  cat("Enter interval length in minutes, or enter \"DONE\":\n")
  input <- readLines("stdin",n=1)
  
  if(input == "DONE"){
    COMPLETE = TRUE
  }else{
    if(input == ""){
      input <- 30
    }else{
      input <- as.numeric(input)
    }
    
    work_times <- c(work_times,input)
  
    calc_times(work_times)
    
  }
  cat("\n\n")
}

if(!is.na(work_times[[1]])){
  cat("Work times (minutes):\n")
  cat(work_times,"\n")
  
  sink(file = "interval-lengths.csv")
  cat(paste0(work_times,collapse = ","))
  sink(file = NULL)
}