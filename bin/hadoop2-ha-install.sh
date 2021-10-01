#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

./bin/role-hadoop2.sh -t install
./bin/role-hadoop2.sh -t install-root -b
./bin/role-hadoop2.sh -t install-ssl -b
./bin/role-hadoop2.sh -t init-ha
