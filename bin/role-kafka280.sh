#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

[ X"$*" == X"" ] && echo "Please write the parameters!" && exit 1

IVPATH=$(cat ansible.cfg | grep "inventory = " | cut -d"=" -f2 | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g')
C_IVPATH="${IVPATH}/kafka-2.8.0"
echo "INVENTORY_PATH =" $C_IVPATH

ansible-playbook 02.kafka.yaml -i "${C_IVPATH}" $*
