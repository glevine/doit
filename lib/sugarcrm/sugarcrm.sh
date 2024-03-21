#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

doit::sugarcrm::usage() {
    echo "Usage: doit sugarcrm [connect|multiverse]" 1>&2
    exit ${1:-0}
}

doit::sugarcrm() {
    if [[ "$#" -eq 0 ]]; then
        doit::sugarcrm::usage 1
    fi

    case $1 in
    connect)
        shift
        doit::sugarcrm::connect "$@"
        ;;
    multiverse)
        shift
        doit::sugarcrm::multiverse "$@"
        ;;
    *)
        doit::sugarcrm::usage 1
        ;;
    esac
}
