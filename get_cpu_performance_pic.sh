#!/bin/bash
today=`date "+%y%m%d%H%M%S"`
times=`expr $time_minutes \* 3`
adb connect $ip
#生成log文件
if [ $type = "platform" ]
then
python ${WORKSPACE}/common/test_threading.py $ip $time_minutes 
fileName=$ip_$today.txt
elif [ $type = "xmj" ]
then
echo "当前运行在小门禁上"
fileName=$ip_$today.txt
for i in $(seq 1 $times)
do
echo $i
echo "catch time "+"`date +%Y%m%d%H%M%S`" >>$fileName
adb -s $ip:5555 shell top -o PID,USER,%CPU,%MEM,VIRT,RES,ARGS -b -n 1 -s 3 | head -n 15 >>$fileName
sleep 20
done
fi
#转化Log文件为excel和png
python ${WORKSPACE}/toPic.py $fileName
