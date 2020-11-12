#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

[ X"$*" == X"" ] && echo "Please write the parameters!" && exit 1

# TODO sed -e部分
IVPATH=$(cat ansible.cfg | grep "inventory = " | cut -d"=" -f2 | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g')
C_IVPATH="${IVPATH}/kafka-ssl"
echo "INVENTORY_PATH =" $C_IVPATH

ansible-playbook 01.ssl.yaml -i "${C_IVPATH}" "$*"
