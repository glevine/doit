#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::scloud::install() {
    if ! command -v scloud &>/dev/null; then
        # FIX: https://sugarcrm.atlassian.net/browse/IDM-2719
        # wget -q --show-progress -O "${HOME}/bin/scloud" https://jenkins.service.sugarcrm.com/job/multiverse/job/monorepo/job/master/lastSuccessfulBuild/artifact/artifacts/bin/scloud-darwin-amd64
        wget -q --show-progress -O "${HOME}/bin/scloud" https://jenkins.service.sugarcrm.com/job/multiverse/job/monorepo/job/master/1244/artifact/artifacts/bin/scloud-darwin-amd64
        chmod +x "${HOME}/bin/scloud"
    else
        # FIX: https://sugarcrm.atlassian.net/browse/IDM-2719
        # scloud update
        echo "scloud can't be updated until https://sugarcrm.atlassian.net/browse/IDM-2719 is fixed"
    fi

    scloud version
}
