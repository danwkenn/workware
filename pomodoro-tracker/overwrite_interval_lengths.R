cat("Enter interval lengths in minutes separated by a space:\n")
work_times <- readLines("stdin",n=1)
work_times <- strsplit(work_times,split = " ")[[1]]

cat("Work times (minutes):\n")
cat(work_times,"\n")

sink(file = "interval-lengths.csv")
cat(paste0(work_times,collapse = ","))
sink(file = NULL)