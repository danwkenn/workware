


calculate_net_day_deficit <- function(){

  suppressMessages(library(lubridate))
  
  #Read in day_data:
  day_data <- read.csv(
    file = "day-data.csv",stringsAsFactors = FALSE
  )
  
  cols <- colnames(day_data)
  for(col in setdiff(cols,"overtime")){
    day_data[[col]] <- as_datetime(day_data[[col]],tz = Sys.timezone(location = TRUE))
  }

  #Calculate deficit for each line:
  day_data$deficit <- NA
  for(i in which(!is.na(day_data$end_time))){
    proposed_day_end <- day_data$start_time[i] + 8 * 60 * 60
    day_data$deficit[i] <- as.numeric(day_data$end_time[i]) - as.numeric(proposed_day_end)
    lunch_time <- (-as.numeric(day_data$lunch_start_time[i]) + 
                     as.numeric(day_data$lunch_end_time[i])) - 30 * 60
    day_data$deficit[i] <- day_data$deficit[i] - lunch_time
  }
  
  #Add up deficit
  deficit <- sum(day_data$deficit[!is.na(day_data$deficit)])
  deficit <- deficit + sum(day_data$overtime) * 60
  AHEAD <- deficit > 0
  message("You are ", ifelse(AHEAD,"ahead","behind"), " by ", format_second_count(abs(round(deficit))))
}