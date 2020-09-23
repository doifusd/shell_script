#!/bin/bash
read -a process_name -p "enter process name such as nginx > " process_name

if [ -z "$process_name" ]; then
read -a process_name -p "enter process name such as nginx > " process_name
fi

phpId=`ps -ef|grep $process_name|awk '{print $2}'`
totalMem=0
totalProcess=0

array=(${phpId//,/ })
for var in ${array[@]}
do
    if [ -f "/proc/$var/smaps" ] ;then
       tmp=`grep Pss "/proc/$var/smaps"|awk '{total+=$2}; END {printf "%d", total }'`
       totalMem=$((${totalMem} + $tmp))
       totalProcess=$((${totalProcess} + 1))
    fi
done

avgMem=$[$totalMem / $totalProcess]
msg="total use physical memory is : "
if [ $totalMem -gt "1000" ];then
totalMem=$[$totalMem / 1024]
totalMem="${totalMem} MB"
else
totalMem="${totalMem} KB"
fi

echo "################### ${process_name} process memory #####################"
echo ${msg} ${totalMem}

echo "total process num is : ${totalProcess} "

echo "avg memory per process is : ${avgMem} KB"

