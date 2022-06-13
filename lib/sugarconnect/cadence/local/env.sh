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

    # An empty secret satisfies the requirements.
    # The secret will be loaded from SUGAR_OAUTH_SA_CLIENT_SECRETS in custom_local.py.
    touch "${CADENCE}/backend/main/src/resources/local/sugar_connect_sa_secret"

    # SUGAR_OAUTH_CLIENT_ID and SUGAR_OAUTH_SA_CLIENT_SECRETS must be filled in.
    cat <<EOF >"${CADENCE}/backend/main/src/config/settings/custom_local.py"
PUBLIC_TENANT_BASE_URL = 'clbspot.localhost.com:28081'
PUBLIC_TENANT_BASE_URL_FULL = 'https://' + PUBLIC_TENANT_BASE_URL
SESSION_COOKIE_DOMAIN = '.clbspot.localhost.com'

HTTP_SCHEME = 'https'

SUGAR_OAUTH_CLIENT_ID = ''
SUGAR_OAUTH_STS_SERVER = 'https://sts-stage.service.sugarcrm.com'
SUGAR_OAUTH_SA_CLIENTS = {'us-west-2': 'srn:stage:iam:us-west-2:9999999999:sa:sugar-connect'}
SUGAR_OAUTH_SA_CLIENT_SECRETS = {'us-west-2': ''}
EOF
}
