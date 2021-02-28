#!/bin/bash

# load shared function
. ansible-common.sh

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

# [ X"$*" == X"" ] && echo "Please write the parameters!" && exit 1

# get
getInventoryPath

echo "end"
# echo "IVPATH = $IVPATH"
# echo "aaaa"

#IVPATH=$(cat ansible.cfg | grep "inventory = " | cut -d"=" -f2 | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g')
#echo "IVPATH = $IVPATH"
#C_IVPATH="${IVPATH}/kafka-2.3.0"
#echo "INVENTORY_PATH =" $C_IVPATH

# ansible-playbook 02.kafka.yaml -i "${C_IVPATH}" $*
