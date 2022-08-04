#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

# Globals.
MULTIVERSE="${HOME}/github.com/sugarcrm/multiverse"
MULTIVERSE_REMOTE_UPSTREAM=git@github.com:sugarcrm/multiverse.git
MULTIVERSE_REMOTE_ORIGIN=git@github.com:glevine/multiverse.git

chores::sugarcrm::multiverse::usage() {
    echo "Usage: chores sugarcrm multiverse [develop]" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::multiverse() {
    if [[ "$#" -eq 0 ]]; then
        chores::sugarcrm::multiverse::usage 1
    fi

    case $1 in
    develop)
        shift
        chores::sugarcrm::multiverse::clone
        chores::sugarcrm::multiverse::bazel::install
        chores::sugarcrm::multiverse::build
        chores::sugarcrm::multiverse::scloud::install
        chores::sugarcrm::multiverse::kubernetes::setup
        chores::sugarcrm::multiverse::docker::login
        chores::sugarcrm::multiverse::aws::configure
        ;;
    *)
        chores::sugarcrm::multiverse::usage 1
        ;;
    esac
}

chores::sugarcrm::multiverse::clone() {
    if [[ ! -d "${MULTIVERSE}" ]]; then
        git clone --recurse-submodules --remote-submodules -o upstream "${MULTIVERSE_REMOTE_UPSTREAM}" "${MULTIVERSE}"
    fi

    git -C "${MULTIVERSE}" submodule update --init --recursive --remote --rebase

    if ! git -C "${MULTIVERSE}" remote | grep -q "^origin$"; then
        git -C "${MULTIVERSE}" remote add origin "${MULTIVERSE_REMOTE_ORIGIN}"
    fi
}

chores::sugarcrm::multiverse::build() {
    (
        cd "${MULTIVERSE}"
        make go-link-stubs
        make go-mod
    )
}
