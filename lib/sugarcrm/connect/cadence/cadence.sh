#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

# Globals.
CADENCE="${HOME}/github.com/sugarcrm/collabspot-cadence"

chores::sugarcrm::connect::cadence::usage() {
    echo "Usage: chores sugarcrm connect cadence [build|deploy]" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::connect::cadence() {
    if [[ "$#" -eq 0 ]]; then
        chores::sugarcrm::connect::cadence::usage 1
    fi

    case $1 in
    build)
        shift
        chores::sugarcrm::connect::cadence::build
        ;;
    deploy)
        shift
        chores::sugarcrm::connect::cadence::deploy "$@"
        ;;
    *)
        chores::sugarcrm::connect::cadence::usage 1
        ;;
    esac
}
