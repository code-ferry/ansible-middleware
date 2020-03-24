#!/bin/bash

ansible-playbook 01.kerberos.yaml -t addprinc
ansible-playbook 01.kerberos.yaml -t createkeytab
ansible-playbook 01.kerberos-client.yaml -t install-config
