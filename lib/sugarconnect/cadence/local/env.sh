#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

shortcuts::sugarconnect::cadence::local::env::build() {
    pyenv install -s "${CADENCE_PYTHON_VERSION}"
    pyenv virtualenv -f "${CADENCE_PYTHON_VERSION}" "sugarconnect@${CADENCE_PYTHON_VERSION}"

    shortcuts::file::append "export DJANGO_SETTINGS_MODULE=config.settings.debug" "${HOME}/.pyenv/versions/$CADENCE_PYTHON_VERSION/envs/sugarconnect@${CADENCE_PYTHON_VERSION}/bin/activate"

    (
        # Enable automatic activation.
        cd "${CADENCE}"
        pyenv local "sugarconnect@${CADENCE_PYTHON_VERSION}"

        # Install python dependencies.
        cd "${CADENCE}/backend/main"
        python -m pip install --upgrade pip-tools
        pip-compile requirements.in
        pip-compile test-requirements.in
        pip-compile dev-requirements.in
        pip-sync requirements.txt test-requirements.txt dev-requirements.txt
    )

    # Use a specific version of node.
    volta install "node@${CADENCE_NODE_VERSION}"

    # Use the latest npm.
    volta install npm
}
