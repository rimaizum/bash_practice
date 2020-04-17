#!/bin/bash

# This script counts the number of failed login attempts by IP address. If there are any IP addresses with more than 10 failed login attempts, the number of attempts made, the IP addresses from which those attempts were made, and the location of the IP address will be displayed.


LIMIT='10'

#Ensure that the user is providing at least one argument for the script

if [[ "${#}" -lt 1 ]]
then
	echo "Please provide one file name that can be parsed through"
	exit 1
fi

if [[ ! -e "${1}" ]]
then
	echo "This log file does not exist."
	exit 1
fi
# Display the CSV header.
echo 'Count,IP,Location'

# Counts the number of failed login attempts

grep Failed syslog-sample | awk '{print $(NF - 3) }' | sort | uniq -c | sort -nr | while read COUNT IP
do

#IF the number of failed attempts is greater then 10, display count, IP, location

if [[ "${COUNT}" -gt "${LIMIT}" ]]
then
	LOCATION=$(geoiplookup ${IP} | awk -F ',' '{print $2}')
	echo "${COUNT},${IP},${LOCATION}"
fi

done
exit 0
