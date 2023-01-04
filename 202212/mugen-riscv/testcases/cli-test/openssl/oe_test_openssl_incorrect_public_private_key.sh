#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2020-07-24
#@License       :   Mulan PSL v2
#@Desc          :   Exception scenarios: the key is incorrect,the public key is incorrect
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    echo "Hello, world!" >word
    openssl genrsa -out rsakey.pem -passout pass:123123 2048
    CHECK_RESULT $?
    grep 'BEGIN RSA PRIVATE KEY' rsakey.pem
    CHECK_RESULT $?
    openssl rsa -in rsakey.pem -pubout -out rsakey-pub.pem
    CHECK_RESULT $?
    grep 'BEGIN PUBLIC KEY' rsakey-pub.pem
    CHECK_RESULT $?
    echo "999" >error_rsakey-pub.pem
    openssl rsautl -encrypt -pubin -inkey error_rsakey-pub.pem -in word -out wordencp2 2>&1 | grep "unable to load Public Key"
    CHECK_RESULT $? 0 0 "Incorrect public key succeeded in encrypting the file"
    openssl rsautl -encrypt -pubin -inkey rsakey-pub.pem -in word -out wordencp2
    CHECK_RESULT $?
    test -f wordencp2
    CHECK_RESULT $?
    echo "999" >error_rsakey.pem
    openssl rsautl -decrypt -inkey error_rsakey.pem -in wordencp2 -out word_replain2 2>&1 | grep 'unable to load Private Key'
    CHECK_RESULT $? 0 0 "The wrong private key successfully decrypted the file"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f $(ls | grep -v "\.sh\|common")
    LOG_INFO "End to restore the test environment."
}

main "$@"
