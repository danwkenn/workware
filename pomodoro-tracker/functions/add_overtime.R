add_overtime <- function(date = Sys.Date(), amount = 30){
  
  date <- ymd(date)
  
  #Read in day_data:
  day_data <- read.csv(
    file = "day-data.csv",stringsAsFactors = FALSE
  )
  
  cols <- colnames(day_data)
  for(col in setdiff(cols,"overtime")){
    day_data[[col]] <- as_datetime(day_data[[col]],tz = Sys.timezone(location = TRUE))
  }
  
  #Find matching date row:
  row = which(as_date(day_data$start_time) == date)
  
  #Add overtime value:
  day_data$overtime[row] <- amount
  
  #Save changes:
  write.table(day_data,file = "day-data.csv",sep = ",",row.names = FALSE)
}