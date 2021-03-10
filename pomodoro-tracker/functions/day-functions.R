pluralise_unit <- function(num,unit){
  if(num == 1){
    return(unit)
  }else{
    return(paste0(unit,"s"))
  }
}

format_second_count <- function(n_seconds){
  string <- ""
  
  if(n_seconds < 60){
    return(paste0(n_seconds, " seconds"))
  }
  
  #Days
  if(n_seconds %/% (24 * 3600) != 0){
    string <- paste0(
      string,
      n_seconds %/% (24 * 3600)," ",
      pluralise_unit((n_seconds %/% (24 * 3600)),"day")
    )
    
    if(n_seconds %% (24 * 3600) != 0){
      string <- paste0(
        string,", "
      )
    }
    
    n_seconds <- n_seconds - n_seconds %/% (24 * 3600) * (24 * 3600)
  }
  
  #Hours
  if(n_seconds %/% (3600) != 0){
    string <- paste0(
      string,
      n_seconds %/% (3600)," ",
      pluralise_unit(n_seconds %/% (3600),"hour")
    )
    
    if(n_seconds %% (3600) != 0){
      string <- paste0(
        string,", "
      )
    }
    n_seconds <- n_seconds - n_seconds %/% (3600) * (3600)
  }
  
  #Minutes
  if(n_seconds %/% (60) != 0){
    string <- paste0(
      string,
      n_seconds %/% (60)," ",
      pluralise_unit(n_seconds %/% (60),"minute")
    )
    n_seconds <- n_seconds - n_seconds %/% (60) * (60)
  }
  
  #Seconds
  if((n_seconds %% 60) != 60){
    string <- paste0(
      string,
      " and ",
      n_seconds %% (60)," ",
      pluralise_unit(n_seconds %% (60),"second")
    )
  }
  return(string)
}

start_day <- function(time = Sys.time()){
  
  if(!is.POSIXct(time)){
    time = as.POSIXct(ymd_hm(paste0(Sys.Date(), " ", time),tz = "Australia/Brisbane"))
  }
  
  temp = data.frame(
    start_time = time,
    end_time = NA,
    lunch_start_time = NA,
    lunch_end_time = NA,
    overtime = 0
  )
  
  #Open table:
  if(file.exists("day-data.csv")){
    #Load data:
    day_data <- read.csv(
      file = "day-data.csv",stringsAsFactors = FALSE
    )
    
    cols <- colnames(day_data)
    for(col in setdiff(cols,"overtime")){
      day_data[[col]] <- as_datetime(day_data[[col]],tz = Sys.timezone(location = TRUE))
    }
    
    day_data <- rbind(day_data,temp)
  }else{
    day_data = temp
  }
  message(day_data$start_time[nrow(day_data)] + 8 * 60 * 60)
  write.table(day_data,file = "day-data.csv",sep = ",",row.names = FALSE)
}

end_day <- function(time = Sys.time()){
  if(!is.POSIXct(time)){
    time = as.POSIXct(ymd_hm(paste0(Sys.Date(), " ", time),tz = "Australia/Brisbane"))
  }
  
  #Load data:
  day_data <- read.csv(
    file = "day-data.csv",stringsAsFactors = FALSE
  )
  
  cols <- colnames(day_data)
  for(col in setdiff(cols,"overtime")){
    day_data[[col]] <- as_datetime(day_data[[col]],tz = Sys.timezone(location = TRUE))
  }
  
  if(is.na(day_data$start_time[nrow(day_data)])){
    stop("Day hasn't been started yet.")
  }
  
  if(is.na(day_data$lunch_start_time[nrow(day_data)])){
    stop("Lunch hasn't been started yet.")
  }
  
  if(is.na(day_data$lunch_start_time[nrow(day_data)])){
    stop("Lunch hasn't been completed yet.")
  }
  
  day_data$end_time[nrow(day_data)] <- time
  
  proposed_day_end <- day_data$start_time[nrow(day_data)] + 8 * 60 * 60
  
  # Calculate deficit:
  deficit <- as.numeric(time) - as.numeric(proposed_day_end)
  lunch_time <- (-as.numeric(day_data$lunch_start_time[nrow(day_data)]) + as.numeric(day_data$lunch_end_time[nrow(day_data)])) - 30 * 60
  deficit <- deficit - lunch_time
  AHEAD <- deficit > 0
  message("You are ", ifelse(AHEAD,"ahead","behind"), " by ", format_second_count(abs(round(deficit))))
  write.table(day_data,file = "day-data.csv",sep = ",",row.names = FALSE)
}

start_lunch <- function(time = Sys.time()){
  
  if(!is.POSIXct(time)){
    time = as.POSIXct(ymd_hm(paste0(Sys.Date(), " ", time),tz = "Australia/Brisbane"))
  }

  #Load data:
  day_data <- read.csv(
    file = "day-data.csv",stringsAsFactors = FALSE
  )
  
  cols <- colnames(day_data)
  for(col in setdiff(cols,"overtime")){
    day_data[[col]] <- as_datetime(day_data[[col]],tz = Sys.timezone(location = TRUE))
  }

  if(is.na(day_data$start_time[nrow(day_data)])){
    stop("Day hasn't been started yet.")
  }
  
  day_data$lunch_start_time[nrow(day_data)] <- time
  
  message(day_data$lunch_start_time[nrow(day_data)] + 30 * 60)
  write.table(day_data,file = "day-data.csv",sep = ",",row.names = FALSE)
}

end_lunch <- function(time = Sys.time()){
  if(!is.POSIXct(time)){
    time = as.POSIXct(ymd_hm(paste0(Sys.Date(), " ", time),tz = "Australia/Brisbane"))
  }
  
  #Load data:
  day_data <- read.csv(
    file = "day-data.csv",stringsAsFactors = FALSE
  )
  
  cols <- colnames(day_data)
  for(col in setdiff(cols,"overtime")){
    day_data[[col]] <- as_datetime(day_data[[col]],tz = Sys.timezone(location = TRUE))
  }
  
  if(is.na(day_data$start_time[nrow(day_data)])){
    stop("Day hasn't been started yet.")
  }
  
  if(is.na(day_data$lunch_start_time[nrow(day_data)])){
    stop("Lunch hasn't been started yet.")
  }
  
  day_data$lunch_end_time[nrow(day_data)] <- time
  
  message(day_data$start_time[nrow(day_data)] + 8 * 60 * 60)
  write.table(day_data,file = "day-data.csv",sep = ",",row.names = FALSE)
}