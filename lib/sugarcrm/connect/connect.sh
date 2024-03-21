#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

doit::sugarcrm::connect::usage() {
    echo "Usage: doit sugarcrm connect [cadence]" 1>&2
    exit ${1:-0}
}

doit::sugarcrm::connect() {
    if [[ "$#" -eq 0 ]]; then
        doit::sugarcrm::connect::usage 1
    fi

    case $1 in
    cadence)
        shift
        doit::sugarcrm::connect::cadence "$@"
        ;;
    *)
        doit::sugarcrm::connect::usage 1
        ;;
    esac
}
