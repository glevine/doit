#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::usage() {
    echo "Usage: chores sugarcrm [connect]" 1>&2
    exit ${1:-0}
}

chores::sugarcrm() {
    if [[ "$#" -eq 0 ]]; then
        chores::sugarcrm::usage 1
    fi

    case $1 in
    connect)
        shift
        chores::sugarcrm::connect "$@"
        ;;
    *)
        chores::sugarcrm::usage 1
        ;;
    esac
}
