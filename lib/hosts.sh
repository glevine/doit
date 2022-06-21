#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

shortcuts::hostname::add() {
    local ip_address=$1
    local hostname=$2
    local listing="${ip_address} ${hostname}"

    # Can't use shortcuts::file:append because we need sudo.
    if ! grep -Fxq "${listing}" /etc/hosts; then
        sudo -- sh -c "echo ${listing} >>/etc/hosts"
    fi
}
