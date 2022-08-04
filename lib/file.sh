#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::file::append() {
    local content=$1
    local file=$2

    if ! grep -Fxq "${content}" "${file}"; then
        echo "${content}" >>"${file}"
    fi
}
