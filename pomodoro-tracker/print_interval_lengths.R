# Load in interval-lengths.csv
work_times <- unlist(suppressWarnings(read.csv("interval-lengths.csv",header = FALSE)))

# Print
cat("Work times (minutes):\n")
cat(work_times,"\n")