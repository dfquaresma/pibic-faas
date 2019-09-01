
#!/bin/bash
date
set -x

echo "EXPID_START: ${EXPID_START:=0}"
echo "EXPID_END: ${EXPID_END:=2}"
echo "FUNCTIONS: ${FUNCTIONS:=thumb listfiller}"

for func in ${FUNCTION};
do
    sudo rm -rf "./results/${func}-container-*.csv"
    for expid in `seq ${EXPID_START} ${EXPID_END}`
    do
        sudo docker rm -f ${func};
        sudo docker run -d --network=host --cpus=1.0 --cpuset-cpus=0 --rm --name ${func} ${func};
        sleep 5
        NUMBER_OF_REQUESTS=10000 URL="localhost:8081" FILE_NAME="./results/${func}-container-${expid}.csv" bash curl-workload.sh;
    done
done

