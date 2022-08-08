#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::projects::bankshot::build() {
    (
        cd "${MULTIVERSE}"
        bazel build //projects/bankshot/...
    )
}

chores::sugarcrm::multiverse::projects::bankshot::deploy() {
    (
        cd "${MULTIVERSE}/k8s/bankshot"
        kubens bankshot
        skaffold run -p dev
    )
}

chores::sugarcrm::multiverse::projects::bankshot::test() {
    (
        cd "${MULTIVERSE}"
        bazel test //projects/bankshot/... --nocache_test_results --test_timeout=15
    )
}

chores::sugarcrm::multiverse::projects::bankshot::view() {
    kubens bankshot
    kubectl get all
}
