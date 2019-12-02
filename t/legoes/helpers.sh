#!/usr/bin/env bash

### BEGIN ###
# Author: lego users
# Since: 15:41:25 19/12/02
# Description:  function about t
# base          source ./helpers.sh
#
# Environment variables that control this script:
#
#   ██▓    ▓█████   ▄████  ▒█████
#  ▓██▒    ▓█   ▀  ██▒ ▀█▒▒██▒  ██▒
#  ▒██░    ▒███   ▒██░▄▄▄░▒██░  ██▒
#  ▒██░    ▒▓█  ▄ ░▓█  ██▓▒██   ██░
#  ░██████▒░▒████▒░▒▓███▀▒░ ████▓▒░
#  ░ ▒░▓  ░░░ ▒░ ░ ░▒   ▒ ░ ▒░▒░▒░
#  ░ ░ ▒  ░ ░ ░  ░  ░   ░   ░ ▒ ▒░
#    ░ ░      ░   ░ ░   ░ ░ ░ ░ ▒
#      ░  ░   ░  ░      ░     ░ ░
#
### END ###

set -e

LEGO_ROOT=$(dirname $(cd $(dirname "$0") && pwd -P)/$(basename "$0"))
COMMON_LEGO_ROOT=${LEGO_ROOT}/lego/legoes/

command -v tccli || pip install tccli

function new_cvm() {
    local name="${1}"
    # https://cloud.tencent.com/document/product/213/15730
    # /usr/local/anaconda3/lib/python3.7/site-packages/tccli/services/cvm/
    tccli cvm RunInstances \
        --InstanceChargeType POSTPAID_BY_HOUR --Placement '{"Zone":"ap-guangzhou-4"}' \
        --InstanceType SA1.SMALL1 \
        --ImageId img-9qabwvbn  \
        --InternetAccessible '{"InternetChargeType":"TRAFFIC_POSTPAID_BY_HOUR","InternetMaxBandwidthOut":1,"PublicIpAssigned":true}' \
        --InstanceCount 1 --InstanceName "${name}" \
        --LoginSettings '{"KeyIds":["skey-aq2p2gjh"]}' --SecurityGroupIds '["sg-4a1rxach"]' 
        # \ --DryRun true
}
