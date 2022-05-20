#!/bin/bash

# change to ansible home directory
FWDIR="$(cd `dirname $0`/..; pwd)"
[ X"$*" == X"" ] && echo "Please write the parameters!" && exit 1

# Define inventory subdir
IVPATH=$(cat ansible.cfg | grep "inventory = " | cut -d"=" -f2 | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g')
C_IVPATH="${IVPATH}/dolphin2"
echo "INVENTORY_PATH =" $C_IVPATH

ansible-playbook 03.dolphin.yaml -i "${C_IVPATH}" $*
