#!/bin/bash

# change to ansible home directory
FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

# load shared function
. ${FWDIR}/bin/ansible-common.sh

# Get inventory path
getInventoryPath

# Define inventory subdir
IV_SUBDIR=test

ansible-playbook 00.test.yaml -i "${IV_PATH}/${IV_SUBDIR}" $*
