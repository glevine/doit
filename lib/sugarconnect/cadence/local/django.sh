#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

chores::sugarconnect::cadence::local::django::manage() {
    cd "${CADENCE}/backend/main/src"
    python manage.py "$@" --settings=config.settings.debug
}
