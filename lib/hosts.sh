#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

doit::hostname::add() {
    local ip_address=$1
    local hostname=$2
    local listing="${ip_address} ${hostname}"

    # Can't use doit::file:append because we need sudo.
    if ! grep -Fxq "${listing}" /etc/hosts; then
        sudo -- sh -c "echo ${listing} >>/etc/hosts"
    fi
}
