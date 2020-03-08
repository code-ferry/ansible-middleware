#!/bin/bash

ansible-playbook 04.kerberos.yaml -t addprinc
ansible-playbook 04.kerberos.yaml -t createkeytab
ansible-playbook 04.kerberos-client.yaml -t install-config
