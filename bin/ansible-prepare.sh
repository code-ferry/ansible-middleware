#!/bin/bash

# change to ansible home directory
FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

# load shared function
. ${FWDIR}/bin/ansible-common.sh

# Get inventory path
getInventoryPath

# Copy host-common configuration file
for IV_SUBDIR in $(ls $IV_PATH)
do
  if [ -d $IV_PATH/$IV_SUBDIR ]; then
    if [[ !($IV_SUBDIR =~ "single") ]]; then
      echo "Copy to $IV_PATH/$IV_SUBDIR"
      cp $IV_PATH/hosts-common $IV_PATH/$IV_SUBDIR/
    fi
  fi
done

echo "Copy config file successfully!"
echo "--------------------------------------------------------------------------------"
echo ""

chmod 744 ./bin/*.sh
echo "Make shell script executable!"
echo "--------------------------------------------------------------------------------"
echo ""
