#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::connect::cadence::remote::deploy::usage() {
    echo "Usage: chores sugarcrm connect cadence deploy <branch> <build> [-c cluster] [-n namespace] [-s]" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::connect::cadence::remote::deploy() {
    if [[ "$#" -ne 2 ]]; then
        chores::sugarcrm::connect::cadence::remote::deploy::usage 1
    fi

    local branch=$1
    local build=$2
    local cluster="k8s-usw2-dev"
    local namespace="sugarconnect"
    local sync=false

    while getopts :c:m:n:s opt; do
        case "${opt}" in
        c)
            cluster=${OPTARG}
            ;;
        h)
            chores::sugarcrm::connect::cadence::remote::deploy::usage 0
            ;;
        n)
            namespace=${OPTARG}
            ;;
        s)
            sync=true
            ;;
        * | \? | :)
            chores::sugarcrm::connect::cadence::remote::deploy::usage 1
            ;;
        esac
    done

    (
        cd "${MULTIVERSE}/k8s/services"

        if [[ $sync = true ]]; then
            git reset --hard HEAD
            git pull
        fi

        kubectx "${cluster}"
        kubens "${namespace}"

        for svc in ${namespace}-{celerybeat,crmdata,csinbox,emailtracking,mailbox,main,materializedviews,provisioner,proxy,smartfolders,twowaysync,worker,backoffice,realtime-sync,realtime-worker}; do
            pushd "${svc}"
            sed -i '' 's|:.*$|:'"${branch}"'\.'"${build}"'|' "docker/${svc}/Dockerfile"
            skaffold run
            popd
        done
    )
}
