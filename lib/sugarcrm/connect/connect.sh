#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::connect::usage() {
    echo "Usage: chores sugarcrm connect [cadence]" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::connect() {
    if [[ "$#" -eq 0 ]]; then
        chores::sugarcrm::connect::usage 1
    fi

    case $1 in
    cadence)
        shift
        chores::sugarcrm::connect::cadence "$@"
        ;;
    *)
        chores::sugarcrm::connect::usage 1
        ;;
    esac
}
