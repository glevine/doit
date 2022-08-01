#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

chores::sugarconnect::usage() {
    echo "Usage: chores sugarconnect [cadence]" 1>&2
    exit ${1:-0}
}

chores::sugarconnect() {
    if [[ "$#" -eq 0 ]]; then
        chores::sugarconnect::usage 1
    fi

    case $1 in
    cadence)
        shift
        chores::sugarconnect::cadence "$@"
        ;;
    *)
        chores::sugarconnect::usage 1
        ;;
    esac
}
