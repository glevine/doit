#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

shortcuts::sugarconnect::cadence::local::deps::resolve() {
    if [[ ! -d "${CADENCE}" ]]; then
        git clone --recurse-submodules --remote-submodules -o upstream "${CADENCE_REMOTE_UPSTREAM}" "${CADENCE}"
    fi

    git -C "${CADENCE}" submodule update --init --recursive --remote --rebase

    if ! git -C "${CADENCE}" remote | grep -q "^origin$"; then
        git -C "${CADENCE}" remote add origin "${CADENCE_REMOTE_ORIGIN}"
    fi

    # PostgreSQL is needed to compile psycopg. The database is actually run in
    # docker.
    if ! command -v postgres &>/dev/null; then
        brew install postgresql
    else
        brew upgrade postgresql
    fi
}
