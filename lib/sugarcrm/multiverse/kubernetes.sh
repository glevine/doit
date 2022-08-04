#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::kubernetes::setup() {
    if [[ $(kubectl config view | grep -q "contexts: null")$? -eq 0 ]]; then
        scloud kubeconfig setup
    else
        scloud kubeconfig sync --email $(whoami)@sugarcrm.com
    fi
}
