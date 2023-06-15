#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

[ X"$*" == X"" ] && echo "Please write the parameters!" && exit 1

ACTION=$1
# 启动prometheus相关
./bin/role-prometheus.sh -t $ACTION
./bin/role-prometheus-pushgateway.sh -t $ACTION
./bin/role-prometheus-node-exporter.sh -t $ACTION
./bin/role-grafana.sh -t $ACTION
