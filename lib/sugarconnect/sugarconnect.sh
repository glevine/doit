#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

shortcuts::sugarconnect::usage() {
    echo "Usage: shortcuts sugarconnect [cadence]" 1>&2
    exit ${1:-0}
}

shortcuts::sugarconnect() {
    if [[ "$#" -eq 0 ]]; then
        shortcuts::sugarconnect::usage 1
    fi

    case $1 in
    cadence)
        shift
        shortcuts::sugarconnect::cadence "$@"
        ;;
    *)
        shortcuts::sugarconnect::usage 1
        ;;
    esac
}
