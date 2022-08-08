#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::projects::scloud::build() {
    (
        cd "${MULTIVERSE}"
        bazel build //projects/scloud/...
    )
}
