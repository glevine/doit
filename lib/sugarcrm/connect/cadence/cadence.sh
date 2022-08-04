#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

# Globals.
CADENCE="${HOME}/github.com/sugarcrm/collabspot-cadence"
CADENCE_NODE_VERSION=12
CADENCE_PYTHON_VERSION=3.9.10
CADENCE_REMOTE_UPSTREAM=git@github.com:sugarcrm/collabspot-cadence.git
CADENCE_REMOTE_ORIGIN=git@github.com:glevine/collabspot-cadence.git

chores::sugarcrm::connect::cadence::usage() {
    echo "Usage: chores sugarcrm connect cadence [build|deploy|develop]" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::connect::cadence() {
    if [[ "$#" -eq 0 ]]; then
        chores::sugarcrm::connect::cadence::usage 1
    fi

    case $1 in
    build)
        shift
        chores::sugarcrm::connect::cadence::local::build
        ;;
    deploy)
        shift
        chores::sugarcrm::connect::cadence::remote::deploy "$@"
        ;;
    develop)
        shift
        chores::sugarcrm::connect::cadence::local::deps::resolve
        chores::sugarcrm::connect::cadence::local::env::build
        chores::sugarcrm::connect::cadence::local::ide::configure
        chores::sugarcrm::connect::cadence::local::build
        ;;
    *)
        chores::sugarcrm::connect::cadence::usage 1
        ;;
    esac
}
