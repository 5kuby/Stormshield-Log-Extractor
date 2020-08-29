# Stormshield-Log-Extractor
A simple script to extract log in a specific time frame from stormshield firewall.

Stormshield firewall store logs in files named l_category where category is the type of logs (example connection, filter, ecc..).
Active log files are called *"open"* log and its name is the one described above, active log file are closed when its size reach 20 Mb and it become a *"closed"* log.
Closed log name format is the fillowing:

**l_category_INDEX_OpeningDate_ClosingDate_NumberOfLines**.

This script can iterate over all log file of a specified category and limit the search operation only to the file wich potentially include entries of interest.

##Wildcard examples

Wildcars are used into grep -E instruction, it means that the expression is evluated as extended one. Tese are examples about this type of wildcard:

-search for 192.168.1.1 or 192.168.1.2 : 192.168.1.[12]
-search for 192.168.1.0/24 : 192.168.1..*
-search for 192.168.10.1 or 192.168.12.1 : 192.168.1[02].1

