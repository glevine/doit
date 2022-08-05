#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

# Globals.
MULTIVERSE="${HOME}/github.com/sugarcrm/multiverse"

chores::sugarcrm::multiverse::usage() {
    echo "Usage: chores sugarcrm multiverse [?]" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::multiverse() {
    if [[ "$#" -eq 0 ]]; then
        chores::sugarcrm::multiverse::usage 1
    fi

    case $1 in
    *)
        chores::sugarcrm::multiverse::usage 1
        ;;
    esac
}
