#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::docker::login() {
    # Log into quay.io.
    if ! grep -q "quay.io" "${HOME}/.docker/config.json"; then
        # Note: Generate encrypted Docker CLI password at
        # https://quay.io/user/$(whoami)?tab=settings.
        unset -v password # make sure `password` isn't already exported
        IFS= read -rs 'password?quay.io password: ' </dev/tty && printf '%s' "${password}" | docker login -u="$(whoami)" --password-stdin quay.io
    fi
}
