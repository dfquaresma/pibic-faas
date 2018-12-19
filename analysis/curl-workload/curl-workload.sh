#!/bin/bash
date
set -x
echo -e "pid,business_time(ms),scavenge_count,scavenge_time,marksweep_count,marksweep_time" > ${FILE_NAME}
for i in `seq 1 ${NUMBER_OF_REQUESTS}`
do
	URL="http://127.0.0.1:8080/function/business-logic-csv"
	curl -X GET ${URL} >> ${FILE_NAME}
	echo "" >> ${FILE_NAME}
done