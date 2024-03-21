#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

doit::sugarcrm::multiverse::projects::cxp::deploy() {
    (
        cd "${MULTIVERSE}/k8s/services/connect-kafka-topics"
        kubens cxp
        skaffold run --force=true
    )
}

doit::sugarcrm::multiverse::projects::cxp::view() {
    kubens cxp
    kubectl get kafkatopic
}
