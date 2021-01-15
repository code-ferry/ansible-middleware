#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

hadoop-daemon.sh stop namenode
ansible-playbook 02.hadoop.yaml -t stop-jn
ansible-playbook 02.zookeeper.yaml -t stop
ansible-playbook 02.hadoop.yaml -t clean
