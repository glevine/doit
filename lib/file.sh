#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

shortcuts::file::append() {
    local content=$1
    local file=$2

    if ! grep -Fxq "${content}" "${file}"; then
        echo "${content}" >>"${file}"
    fi
}
