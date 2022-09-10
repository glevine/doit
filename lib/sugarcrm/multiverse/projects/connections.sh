#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::projects::connections::deploy() {
    # Deploy Kafka topics.
    chores::sugarcrm::multiverse::deploy::project cxp

    # Deploy bankshot.
    chores::sugarcrm::multiverse::deploy::project bankshot

    # Deploy connections.
    (
        cd "${MULTIVERSE}/k8s/services/connections"
        kubens connections
        skaffold run -p dev
    )
}
