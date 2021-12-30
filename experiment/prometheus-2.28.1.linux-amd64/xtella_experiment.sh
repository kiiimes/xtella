#!/bin/sh

docker1=`docker ps | grep hotel-reserv | awk '{print $1}'`
docker2=`docker ps | grep consul_consul | awk '{print $1}'`
docker3=`docker ps | grep POD | awk '{print $1}'`
docker ps | grep hotel-reserv >> perf_data/docker1.txt
docker ps | grep consul_consul >> perf_data/docker2.txt
docker ps | grep POD >> perf_data/docker3.txt

event=`perf list | grep "offcore_response"`

for id in $docker1
do
	pid=`pgrep containerd-shim -a | grep $id | awk '{print $1}'`
	perf stat -d -d -d -o perf_data/$pid.txt -p $pid -e `echo $event$i | sed -e "s/ /,/g"` sleep 60&
	echo $pid >> perf_data/docker1.txt
done
pid=`pgrep containerd-shim -a | grep $docker2 | awk '{print $1}'`
perf stat -d -d -d -o perf_data/$pid.txt -p $pid -e `echo $event$i | sed -e "s/ /,/g"` sleep 60 &
echo $pid >> perf_data/docker2.txt

for id in $docker3
do
	pid=`pgrep containerd-shim -a | grep $id | awk '{print $1}'`
	perf stat -d -d -d -o perf_data/$pid.txt -p $pid -e `echo $event$i | sed -e "s/ /,/g"` sleep 60&
	echo $pid >> perf_data/docker3.txt
done

time1=`date "+%s"`
echo $time1 >> time.txt
p=`ps -ef | grep perf | awk '{print $2}'`
wait $p
time2=`date "+%s"`
echo $time2 >> time.txt

