#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

./bin/role-hadoop2.sh -t repair-ha
