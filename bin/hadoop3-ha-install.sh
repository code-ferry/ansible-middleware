#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

./bin/role-hadoop3.sh -t install
./bin/role-hadoop3.sh -t install-root -b
./bin/role-hadoop3.sh -t install-ssl -b
./bin/role-hadoop3.sh -t install-cgroup -b
./bin/role-hadoop3.sh -t init-ha
