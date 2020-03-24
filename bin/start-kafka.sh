#!/bin/bash

ansible-playbook 02.zookeeper.yaml -t start
ansible-playbook 02.kafka.yaml -t start
