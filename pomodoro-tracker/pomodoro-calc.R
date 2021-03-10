args = commandArgs(trailingOnly=TRUE)

if(length(args) == 0){
  thinking_time = 0  
}else{
  thinking_time = as.numeric(args[[1]])
}

if(length(args) < 2){
  other_time <- 0
}else{
  other_time <- as.numeric(args[[2]])
}

work_times <- unlist(suppressWarnings(read.csv("interval-lengths.csv",header = FALSE)))
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
