#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

# Globals.
CADENCE="${HOME}/github.com/sugarcrm/collabspot-cadence"

doit::sugarcrm::connect::cadence::usage() {
    echo "Usage: doit sugarcrm connect cadence [build|deploy]" 1>&2
    exit ${1:-0}
}

doit::sugarcrm::connect::cadence() {
    if [[ "$#" -eq 0 ]]; then
        doit::sugarcrm::connect::cadence::usage 1
    fi

    case $1 in
    build)
        shift
        doit::sugarcrm::connect::cadence::build
        ;;
    deploy)
        shift
        doit::sugarcrm::connect::cadence::deploy "$@"
        ;;
    *)
        doit::sugarcrm::connect::cadence::usage 1
        ;;
    esac
}
