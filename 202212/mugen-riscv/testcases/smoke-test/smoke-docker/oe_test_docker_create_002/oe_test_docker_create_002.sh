#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-06-08
# @License   :   Mulan PSL v2
# @Desc      :   Creating an interactive container
# ############################################

source ../common/prepare_docker.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_docker_env
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    expect -c "
    log_file testlog
    spawn docker run -it ${Images_name}
    sleep 5
    expect {
    \"*#*\" {send \"ls\r\"
    expect  \"*#*\" {send \"pwd\r\"}
    expect  \"*#*\" {send \"exit\r\"}
}
}
"
    grep -iE 'error|fail' testlog
    CHECK_RESULT $? 1
    grep -E 'bin|dev' testlog
    CHECK_RESULT $?
    grep pwd -A 1 testlog | tail -1 | grep -w '/'
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_docker_env
    DNF_REMOVE
    rm -rf testlog
    LOG_INFO "Finish environment cleanup."
}

main $@
