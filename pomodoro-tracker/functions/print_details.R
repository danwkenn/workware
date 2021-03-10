print_details <- function(n){

suppressMessages(library(lubridate))

#Load data:
day_data <- read.csv(
  file = "day-data.csv",stringsAsFactors = FALSE
)

cols <- colnames(day_data)
for(col in setdiff(cols,"overtime")){
  day_data[[col]] <- as_datetime(day_data[[col]],tz = Sys.timezone(location = TRUE))
}

n <- min(n,nrow(day_data))

print(day_data[(nrow(day_data)-n+1):nrow(day_data),])
}