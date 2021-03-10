#!/bin/bash

if [ "$1" = "calc" ]
then
  Rscript pomodoro-calc.R $2 $3
fi

if [ "$1" = "modify" ]
then
  Rscript modify_interval_lengths.R $2 $3
fi

if [ "$1" = "print" ]
then
  Rscript print_interval_lengths.R
fi

if [ "$1" = "run" ]
then
  Rscript pomodoro-main.R $2
fi

if [ "$1" = "overwrite" ]
then
  Rscript overwrite_interval_lengths_alpha.R
fi

if [ "$1" = "import" ]
then
  Rscript import_song_list.R $2 $3
fi

if [ "$1" = "scrape" ]
then
  Rscript scrape_spotify_discover.R "$2" "$3"
fi