#!/bin/bash
phpId=`ps -ef|grep $1|awk '{print $2}'`
totalMemory=0
totalProcess=0

array=(${phpId//,/ })
for var in ${array[@]}
do
    if [ -f "/proc/$var/smaps" ] ;then
       tmp=`grep Pss "/proc/$var/smaps"|awk '{total+=$2}; END {printf "%d", total }'`
       totalMemory=$((${totalMemory} + $tmp))
       totalProcess=$((${totalProcess} + 1))
    fi
done

vagMem=$[$totalMemory / $totalProcess]
msg="总计使用物理内存是: "
if [ $totalMemory > 1000 ];then
totalMemory=$[$totalMemory / 1024]
totalMemory="${totalMemory} MB"
else
totalMemory="${totalMemory} KB"
fi

echo "#####################进程内存统计################################"
echo ${msg} ${totalMemory}

echo "总计执行进程数是: ${totalProcess} 个"

echo "平均每个进程使用内存大小是: ${vagMem} KB"

