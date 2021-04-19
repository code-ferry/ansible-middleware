#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"

[ X"$*" == X"" ] && echo "Please write the parameters!" && exit 1

IVPATH=$(cat ansible.cfg | grep "inventory = " | cut -d"=" -f2 | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g')
C_IVPATH="${IVPATH}/etcd"
echo "INVENTORY_PATH =" $C_IVPATH

ansible-playbook 03.etcd.yaml -i "${C_IVPATH}" $*
