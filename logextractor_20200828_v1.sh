#!/bin/sh
echo "insert log search start date in yyyymmdd format:"
read start_date
echo "insert log search start time in hh:mm:ss format:"
read start_time
echo "insert log search end date in yyyymmdd format:"
read end_date
echo "insert log search end time in hh:mm:ss format:"
read end_time

#When a log file is archived SNS add a string to filename with time references in the format yyyymmddhhmmss the following instruction adapt start time to this format
normalized_time=$(echo "$start_time" | awk -F: '{print $1$2$3}')

#The following code is to ask log type, ip addresses and time frame
echo "Select log type:
1) Connection log
2) Filter log
3) Alarm log
"
read selection
if [ $selection == 1 ]
then 
 log_type=connection
elif [ $selection == 2 ]
 then
  log_type=filter
elif [ $selection == 3 ]
 then
  log_type=alarm
else
echo "wrong selection"  
fi
echo "insert source ip (wildcard is supported):"
read srcip
echo "insert destination ip (wildcard is supported):"
read dstip
echo "insert output file name with path (example: /log/myoutfile):"
read outfile

#start_time_refenrence is composed by date and time var and is used to find log files which can contain logs we are looking for
start_time_reference=$start_date$normalized_time


#This for loop search in all logs of the type specified during the wizard 
#but execute a grep instrucion only against logs which have a close reference more recent 
#than the time reference given in the wizard 
for logfile in $(ls /log/l_$log_type*)
do
 filedate=$(echo $logfile | cut -f5 -d'_') #cut extract the 5th field (close time) from a log file name using underscore as separator
 if [ $logfile == /log/l_connection ] #this is set filedate to 99999999999999 in order to include l_connection file in the search in case of absence of search extended to the actual time
  then
   filedate=99999999999999
 fi
 if [ $filedate -ge $start_time_reference ] # if filedate (log close time) is greater or equal to the start time reference it means that the file can contain logs generated in the search time frame 
  then
   echo "grep in $logfile"
   grep -E $srcip'\>' $logfile | grep -E $dstip'\>' >> /tmp/log_extractor_tempfile #execute a grep with extended expression and write the result in a tmp file 
 fi
done

#the code below select log files wich can contain logs generated in the search time frame but there's a case in wich a log file was created
#before the start search time, in this case we'll find also logs generated before this time, to avoid this situation a second loop is executed
#against the tmp file. This loop apply the same logic described above but this time for each log entry. Logs generated before search start time
#will not be copied to the output file.

while read line 
 do
  line_ref=$(echo $line| cut -f2,3 -d' '| sed 's/[^0-9]*//g')
  if [ $line_ref -ge $start_time_reference ]
   then
    echo "$line" >> $outfile
  fi
done </tmp/log_extractor_tempfile
rm /tmp/log_extractor_tempfile
