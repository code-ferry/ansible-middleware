#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

./bin/role-hadoop3.sh -t stop
./bin/role-hadoop3.sh -t repair-ha
