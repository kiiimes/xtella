#!/bin/sh

time1=`date "+%s"`
echo $time1 >> time.txt
./pcm.x 1 -i=60 -csv=mem_llc_bandwidth.csv
time2=`date "+%s"`
echo $time2 >> time.txt
