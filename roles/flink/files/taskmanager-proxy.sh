#!/bin/bash

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. "$bin"/config.sh

CMD=$1

count=1
if [ -n "$2" ];
 then
  count=$2
fi;

echo "当前执行命令：${CMD}"
echo "当前Flink路径$FLINK_HOME"

currentInstance=$(ps -ef|grep TaskManagerRunner|grep "${FLINK_HOME}"|grep -v grep|wc -l)
echo "当前TM个数${currentInstance} 目标示例数 ${count}"



if [ "$1" ==  "start" ]
 then
    for((i=${currentInstance};i<${count};i++))
    do
      "$FLINK_BIN_DIR"/taskmanager.sh "${CMD}"  
    done
else
  echo "执行${CMD}"
  "$FLINK_BIN_DIR"/taskmanager.sh "${CMD}"
fi
