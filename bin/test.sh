#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

ansible-playbook 02.hadoop.yaml -t clean
ansible-playbook 02.zookeeper.yaml -t start
ansible-playbook 02.hadoop.yaml -t start-jn

hdfs namenode -format ns
hadoop-daemon.sh start namenode
