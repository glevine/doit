#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

# Globals.
CADENCE="${HOME}/github.com/collabspot/collabspot-cadence"
CADENCE_NODE_VERSION=12
CADENCE_PYTHON_VERSION=3.9.10
CADENCE_REMOTE_UPSTREAM=git@github.com:collabspot/collabspot-cadence.git
CADENCE_REMOTE_ORIGIN=git@github.com:glevine/collabspot-cadence.git

shortcuts::sugarconnect::cadence::usage() {
    echo "Usage: shortcuts sugarconnect cadence [build|deploy|develop]" 1>&2
    exit ${1:-0}
}

shortcuts::sugarconnect::cadence() {
    if [[ "$#" -eq 0 ]]; then
        shortcuts::sugarconnect::cadence::usage 1
    fi

    case $1 in
    build)
        shift
        shortcuts::sugarconnect::cadence::local::build
        ;;
    deploy)
        shift
        shortcuts::sugarconnect::cadence::remote::deploy "$@"
        ;;
    develop)
        shift
        shortcuts::sugarconnect::cadence::local::deps::resolve
        shortcuts::sugarconnect::cadence::local::env::build
        shortcuts::sugarconnect::cadence::local::ide::configure
        shortcuts::sugarconnect::cadence::local::build
        ;;
    *)
        shortcuts::sugarconnect::cadence::usage 1
        ;;
    esac
}
