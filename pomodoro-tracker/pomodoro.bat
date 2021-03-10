@echo off
::First argument says which file to use.

IF "%1"=="calc" (
	Rscript pomodoro-calc.R %2 %3
)

IF "%1"=="modify" (
	Rscript modify_interval_lengths.R %2 %3
)

IF "%1"=="print" (
	Rscript print_interval_lengths.R
)

IF "%1"=="run" (
	Rscript pomodoro-main.R %2
)

IF "%1"=="overwrite" (
	Rscript overwrite_interval_lengths_alpha.R
)

IF "%1"=="import" (
  Rscript import_song_list.R %2 %3
)