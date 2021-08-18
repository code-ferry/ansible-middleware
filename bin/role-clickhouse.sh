#!/bin/bash

FWDIR="$(
  cd $(dirname $0)/..
  pwd
)"
cd ${FWDIR}

[ X"$*" == X"" ] && echo "Please write the parameters!" && exit 1

IVPATH=$(cat ansible.cfg | grep "inventory = " | cut -d"=" -f2 | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g')
C_IVPATH="${IVPATH}/clickhouse"
echo "INVENTORY_PATH =" $C_IVPATH

if [ $2 == "install" ]; then
  ansible-playbook 03.clickhouse.yaml -i "${C_IVPATH}" -t install-root -b
  ansible-playbook 03.clickhouse.yaml -i "${C_IVPATH}" -t install
elif [ $2 == "uninstall" ]; then
  ansible-playbook 03.clickhouse.yaml -i "${C_IVPATH}" -t uninstall
  ansible-playbook 03.clickhouse.yaml -i "${C_IVPATH}" -t uninstall-root -b
else
  ansible-playbook 03.clickhouse.yaml -i "${C_IVPATH}" $*
fi


