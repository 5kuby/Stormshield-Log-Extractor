# Stormshield-Log-Extractor
A simple script to extract log in a specific time frame from stormshield firewall.
Stormshield firewall store logs in files named l_category where category is the type of logs (example connection, filter, ecc..).
Active log files are called "open" log and its name is the one described above, active log file are closed when its size reach 20 Mb and it become a closed log.
Closed log name format is the fillowing:
l_category_INDEX_OpeningDate_ClosingDate_NumberOfLines
This script can iterate over all log file of a specified category and limit the search operation only to the file wich potentially include entries of interest.
