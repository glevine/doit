#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::connect::cadence::django::manage() {
    cd "${CADENCE}/backend/main/src"
    python manage.py "$@" --settings=config.settings.debug
}
