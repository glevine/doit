#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::aws::configure() {
    # Configure AWS CLI for use with sugararch account.
    local username=$(whoami)@sugarcrm.com

    if ! grep -q "${username}" "${HOME}/.aws/config" || ! grep -q "${username}" "${HOME}/.aws/credentials"; then
        # Note: Create access key as described at
        # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.
        # Or, copy an access key from ~/.aws/credentials and transfer it to
        # another machine to use an existing access key.
        aws configure --profile "${username}"
    fi
}
