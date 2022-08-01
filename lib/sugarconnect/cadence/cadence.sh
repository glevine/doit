#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

# Globals.
CADENCE="${HOME}/github.com/sugarcrm/collabspot-cadence"
CADENCE_NODE_VERSION=12
CADENCE_PYTHON_VERSION=3.9.10
CADENCE_REMOTE_UPSTREAM=git@github.com:sugarcrm/collabspot-cadence.git
CADENCE_REMOTE_ORIGIN=git@github.com:glevine/collabspot-cadence.git

chores::sugarconnect::cadence::usage() {
    echo "Usage: chores sugarconnect cadence [build|deploy|develop]" 1>&2
    exit ${1:-0}
}

chores::sugarconnect::cadence() {
    if [[ "$#" -eq 0 ]]; then
        chores::sugarconnect::cadence::usage 1
    fi

    case $1 in
    build)
        shift
        chores::sugarconnect::cadence::local::build
        ;;
    deploy)
        shift
        chores::sugarconnect::cadence::remote::deploy "$@"
        ;;
    develop)
        shift
        chores::sugarconnect::cadence::local::deps::resolve
        chores::sugarconnect::cadence::local::env::build
        chores::sugarconnect::cadence::local::ide::configure
        chores::sugarconnect::cadence::local::build
        ;;
    *)
        chores::sugarconnect::cadence::usage 1
        ;;
    esac
}
