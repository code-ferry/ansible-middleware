#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

ansible-playbook 02.hadoop.yaml -t stop
ansible-playbook 02.hadoop.yaml -t clean
ansible-playbook 02.hadoop.yaml -t install

ansible-playbook 02.hadoop.yaml -t install-root -e "ansible_become=true"
ansible-playbook 02.hadoop.yaml -t format
ansible-playbook 02.hadoop.yaml -t install-cgroup -e "ansible_become=true"
