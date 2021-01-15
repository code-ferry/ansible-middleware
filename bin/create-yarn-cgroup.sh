#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

ansible-playbook 02.hadoop.yaml -t install-cgroup -e "ansible_become=true"