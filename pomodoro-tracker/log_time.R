args = commandArgs(trailingOnly=TRUE)

suppressMessages(library(lubridate))

source("functions/day-functions.R")
source("functions/calculate_net_day_deficit.R")
source("functions/print_details.R")
source("functions/add_overtime.R")
if(length(args) >=3){
  time = args[[3]]
}else{
  time = Sys.time()
}

if(args[[1]] == "overtime"){
  date <- (args[[2]])
  amount <- args[[3]]
  add_overtime(date,amount)
}

if(args[[1]] == "print"){
  n <- as.numeric(args[[2]])
  print_details(n)
}

if(args[[1]] == "net"){
  calculate_net_day_deficit()
}

if(args[[1]] == "day"){
    if(args[[2]] == "start"){
      start_day(time = time)
    }
    if(args[[2]] == "end"){
      end_day(time = time)
    }
}

if(args[[1]] == "lunch"){
  if(args[[2]] == "start"){
    start_lunch(time = time)
  }
  if(args[[2]] == "end"){
    end_lunch(time = time)
  }
}
