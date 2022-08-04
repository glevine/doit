#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::bazel::install() {
    # Install bazelisk.
    if ! command -v bazelisk &>/dev/null; then
        brew install bazelisk
    else
        brew upgrade bazelisk
    fi

    chores::sugarcrm::multiverse::bazel::test
}

chores::sugarcrm::multiverse::bazel::test() {
    (
        # Test bazel installation.
        cd "${MULTIVERSE}"
        bazel info
        make diagnostics
    )
}
