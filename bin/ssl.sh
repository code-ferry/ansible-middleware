#!/bin/bash

FWDIR="$(cd `dirname $0`/..; pwd)"
cd ${FWDIR}

ansible-playbook 01.ssl.yaml $*
