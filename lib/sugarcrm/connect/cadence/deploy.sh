#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::connect::cadence::deploy::usage() {
    echo "Usage: chores sugarcrm connect cadence deploy <branch> <build> [-n namespace] [-s]" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::connect::cadence::deploy() {
    local namespace="sugarconnect"
    local sync=false

    local pos_args # Holds positional arguments.
    pos_args=()

    while [ $# -gt 0 ]; do
        while getopts "hn:s" opt; do
            case "${opt}" in
            h)
                chores::sugarcrm::connect::cadence::deploy::usage 0
                ;;
            n)
                namespace=${OPTARG}
                ;;
            s)
                sync=true
                ;;
            * | \? | :)
                chores::sugarcrm::connect::cadence::deploy::usage 1
                ;;
            esac
        done

        [ $OPTIND -gt $# ] && break # No more arguments.

        shift $(($OPTIND - 1)) # Free already processed options.
        OPTIND=1               # Reset OPTIND.
        pos_args+=$1           # Save the next positional argument.
        shift                  # Remove the saved argument.
    done

    if [[ "${#pos_args}" -ne 2 ]]; then
        chores::sugarcrm::connect::cadence::deploy::usage 1
    fi

    # Assign positional arguments.
    local branch="${pos_args[1]}"
    local build="${pos_args[2]}"

    (
        cd "${MULTIVERSE}/k8s/services"

        if [[ $sync = true ]]; then
            git reset --hard HEAD
            git pull
        fi

        kubectx k8s-usw2-dev
        kubens "${namespace}"

        for svc in ${namespace}-{celerybeat,crmdata,csinbox,emailtracking,mailbox,main,materializedviews,provisioner,proxy,smartfolders,twowaysync,worker,backoffice,realtime-sync,realtime-worker}; do
            pushd "${svc}"
            sed -i'' 's|:.*$|:'"${branch}"'\.'"${build}"'|' "docker/${svc}/Dockerfile"
            skaffold run --force=true
            popd
        done
    )
}
