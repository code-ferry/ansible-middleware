#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

# clean中已经包含stop.
./bin/role-pulsar.sh -t clean
./bin/role-pulsar.sh -t install
./bin/role-pulsar.sh -t init
