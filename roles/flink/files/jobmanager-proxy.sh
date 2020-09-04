#!/bin/bash

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. "$bin"/config.sh

CMD=$1
host=$2
webport=$3


if [ "$1" ==  "start" ]
 then
    currentInstance=$(ps -ef|grep StandaloneSessionClusterEntrypoint|grep "${FLINK_HOME}"|grep -v grep|wc -l) 
    echo "当前JM个数${currentInstance} 目标示例数 1"
    for((i=${currentInstance};i<1;i++))
    do
      "$FLINK_BIN_DIR"/jobmanager.sh "${CMD}" "${host}" "${webport}" 
    done
else
  echo "执行${CMD}"
  "$FLINK_BIN_DIR"/jobmanager.sh "${CMD}"
fi
