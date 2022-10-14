#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::projects::cxp::deploy() {
    (
        cd "${MULTIVERSE}/k8s/services/connect-kafka-topics"
        kubens cxp
        skaffold run --force=true
    )
}

chores::sugarcrm::multiverse::projects::cxp::view() {
    kubens cxp
    kubectl get kafkatopic
}
