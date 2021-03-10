args = commandArgs(trailingOnly=TRUE)

if(length(args) == 0){
  ADD = TRUE
}else{
  if(!(args[[1]] %in% c("add","remove"))){
    stop("Unexpected input: \"",args[[1]],"\". Only \"add\" or \"remove\" are accepted inputs.")
  }
  ADD = (args[[1]] == "add")
}

if(length(args) > 1){
  amount <- as.numeric(args[[2]])
}else{
  amount = 5
}

# Load in interval-lengths.csv
work_times <- unlist(suppressWarnings(read.csv("interval-lengths.csv",header = FALSE)))

# If nothing in it, then add 10 minutes
if(length(work_times) == 0){
  if(!ADD){
    stop("Work times is already empty!")
  }
  work_times <- 10
}

if(!ADD){
  work_times <- work_times[-amount]
}else{

# Else find largest value, then add 5 + largest value.
peak <- which.max(work_times)
new_peak <- work_times[peak] + amount
work_times <- c(work_times[1:peak],new_peak,work_times[peak:1])
}

# Save
cat("Work times (minutes):\n")
cat(work_times,"\n")

sink(file = "interval-lengths.csv")
cat(paste0(work_times,collapse = ","))
sink(file = NULL)