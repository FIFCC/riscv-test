#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test systemd-journal-catalog-update.service restart
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    service=systemd-journal-catalog-update.service
    test -f /var/.updated && mv /var/.updated /var/.updated_bak
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution "${service}"
    test_reload "${service}"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    systemctl stop "${service}"
    test -f /var/.updated_bak && mv /var/.updated_bak /var/.updated
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
