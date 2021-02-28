#!/bin/bash

function getInventoryPath() {
  IVPATH=$(cat ansible.cfg | grep "inventory = " | cut -d"=" -f2 | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g')
  echo "Inventory Path = "$IVPATH
}
