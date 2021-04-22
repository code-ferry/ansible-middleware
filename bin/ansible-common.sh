#!/bin/bash

function getInventoryPath() {
  IV_PATH=$(cat ansible.cfg | grep "inventory = " | cut -d"=" -f2 | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g')
  
  if [ X"" == X"$IV_PATH" ]; then
      echo "Inventory path is empty!"
      return 1
  fi
  echo "Inventory Path = "$IV_PATH
}
