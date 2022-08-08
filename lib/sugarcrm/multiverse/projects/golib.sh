#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::projects::golib::build() {
    (
        cd "${MULTIVERSE}"
        bazel build //projects/golib/...
    )
}

chores::sugarcrm::multiverse::projects::golib::test() {
    (
        cd "${MULTIVERSE}"
        bazel test //projects/golib/...
    )
}
