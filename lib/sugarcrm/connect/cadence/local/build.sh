#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::connect::cadence::local::build() {
    chores::hostname::add 127.0.0.1 clbspot.localhost.com
    chores::hostname::add 127.0.0.1 sugarcrm.clbspot.localhost.com

    # Build the application.
    (
        cd "${CADENCE}"
        make scratch
    )

    # Link the portal.
    # ln -sf "${CADENCE}/sugar-connect-portal/dist/sugar-connect-portal" "${CADENCE}/backend/main/src/static/app"

    chores::sugarcrm::connect::cadence::local::django::manage refresh_sa_tokens
}
