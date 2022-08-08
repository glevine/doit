#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::projects::connections::build() {
    (
        cd "${MULTIVERSE}"
        bazel build //projects/connections/...
    )
}

chores::sugarcrm::multiverse::projects::connections::deploy() {
    # Deploy Kafka topics.
    chores::sugarcrm::multiverse::projects::cxp::deploy

    # Deploy bankshot.
    chores::sugarcrm::multiverse::projects::bankshot::deploy

    # Deploy connections.
    (
        cd "${MULTIVERSE}/k8s/connections"
        kubens connections
        skaffold run -p dev
    )
}

chores::sugarcrm::multiverse::projects::bankshot::test() {
    (
        cd "${MULTIVERSE}"
        bazel test //projects/connections/... --nocache_test_results --test_timeout=15
    )
}

chores::sugarcrm::multiverse::projects::connections::view() {
    kubens connections
    kubectl get all
}
