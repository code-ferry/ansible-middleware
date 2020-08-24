#!/usr/bin/env bash
################################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

NLTMSlaves() {
    CMD=$1
    count=$2
    echo "${count}"

    readSlaves

    if [ ${SLAVES_ALL_LOCALHOST} = true ] ; then
        # all-local setup
        for slave in ${SLAVES[@]}; do
            "${FLINK_BIN_DIR}"/taskmanager.sh "${CMD}" "${count}"
        done
    else
        # non-local setup
        # Stop TaskManager instance(s) using pdsh (Parallel Distributed Shell) when available
        command -v pdsh >/dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            for slave in ${SLAVES[@]}; do
                ssh -n $FLINK_SSH_OPTS $slave -- "nohup /bin/bash -l \"${FLINK_BIN_DIR}/taskmanager-proxy.sh\" \"${CMD}\"  \"${count}\" &"
            done
        else
            PDSH_SSH_ARGS="" PDSH_SSH_ARGS_APPEND=$FLINK_SSH_OPTS pdsh -w $(IFS=, ; echo "${SLAVES[*]}") \
                "nohup /bin/bash -l \"${FLINK_BIN_DIR}/taskmanager-proxy.sh\" \"${CMD}\"  \"{count}\" "
        fi
    fi
}

