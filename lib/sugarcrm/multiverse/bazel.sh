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

    # rules_docker requires python2. python2 is not present on macOS 12. As a
    # workaround until multiverse uses rules_docker-0.24.0, the following
    # installs python2 and prioritizes python3 globally. Once python2 is no
    # longer necessary, unset it with:
    # pyenv global system; pyenv uninstall 3.10.6; pyenv uninstall 2.7.18;
    if [[ $(pyenv versions | grep -q "3.10.6")$? -eq 0 ]]; then
        pyenv install 3.10.6
    fi
    if [[ $(pyenv versions | grep -q "2.7.18")$? -eq 0 ]]; then
        pyenv install 2.7.18
    fi
    pyenv global 3.10.6 2.7.18

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
