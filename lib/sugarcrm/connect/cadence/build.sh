#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

doit::sugarcrm::connect::cadence::build() {
    doit::hostname::add 127.0.0.1 clbspot.localhost.com
    doit::hostname::add 127.0.0.1 sugarcrm.clbspot.localhost.com

    # Build the application.
    (
        cd "${CADENCE}"
        make scratch
    )

    # Link the portal.
    ln -sf "${CADENCE}/sugar-connect-portal/dist/sugar-connect-portal" "${CADENCE}/backend/main/src/static/app"

    doit::sugarcrm::connect::cadence::django::manage refresh_sa_tokens
}
