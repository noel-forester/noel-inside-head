#!/bin/bash

watch_dir="/mnt/lvm/record/work/recording/"
output_dir="/mnt/lvm/record/work/encording/"
complete_dir="/mnt/lvm/record/encorded/"
logfile_path="/mnt/lvm/record/encord_log.log"
fail_dir="/mnt/lvm/record/encord_fail/"

#roop
inotifywait -e moved_to,close_write --format '%f' -mq $watch_dir | while read line; do
        filename_in=$line
        filename_out=${filename_in%.*}.mp4

#set variable
		file_in="$watch_dir""$filename_in"
		file_out="$output_dir""$filename_out"
		file_complete="$complete_dir""$filename_out"

#encord_background
(
	(
		echo "`date "+%F %T"` $filename_out encode start!" >> $logfile_path;
		ffmpeg -i "$file_in" -vcodec h264_omx -vb 9000k "$file_out" &&
		mv "$file_out" "$file_complete" &&
		rm "$file_in" &&
		echo "`date "+%F %T"` $filename_out encode complete!" >> $logfile_path
	)||( 
		rm "$output_dir""$filename_out" ;
		mv "$file_in" "$fail_dir" ;
		echo "`date "+%F %T"` $filename_out encode fail!" >> $logfile_path
	)
) &

done
