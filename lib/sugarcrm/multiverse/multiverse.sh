#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

# Globals.
MULTIVERSE="${HOME}/github.com/sugarcrm/multiverse"

doit::sugarcrm::multiverse::usage() {
    echo "Usage: doit sugarcrm multiverse [build|deploy|test|view]" 1>&2
    exit ${1:-0}
}

doit::sugarcrm::multiverse() {
    if [[ "$#" -eq 0 ]]; then
        doit::sugarcrm::multiverse::usage 1
    fi

    case $1 in
    build)
        shift
        doit::sugarcrm::multiverse::build "$@"
        ;;
    deploy)
        shift
        doit::sugarcrm::multiverse::deploy "$@"
        ;;
    test)
        shift
        doit::sugarcrm::multiverse::test "$@"
        ;;
    view)
        shift
        doit::sugarcrm::multiverse::view "$@"
        ;;
    *)
        doit::sugarcrm::multiverse::usage 1
        ;;
    esac
}
