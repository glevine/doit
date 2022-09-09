#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::view::usage() {
    echo "Usage: chores sugarcrm multiverse view [-c cluster] [-r region] [-w workload1,workload2,...,workloadN] -p project1,project2,...,projectN" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::multiverse::view() {
    local cluster="dev"
    local projects
    local region="usw2"
    local workloads="all"

    while getopts c:h:p:r:w: opt; do
        case "${opt}" in
        c)
            cluster=${OPTARG}
            ;;
        h)
            chores::sugarcrm::multiverse::view::usage 0
            ;;
        p)
            projects=${OPTARG}
            ;;
        r)
            region=${OPTARG}
            ;;
        w)
            workloads=${OPTARG}
            ;;
        * | \? | :)
            chores::sugarcrm::multiverse::view::usage 1
            ;;
        esac
    done

    if [[ -z "${projects}" ]]; then
        chores::sugarcrm::multiverse::view::usage 1
    fi

    kubectx "k8s-${region}-${cluster}"

    for project in $(echo ${projects} | sed "s/,/ /g"); do
        local fn="chores::sugarcrm::multiverse::projects::${project}::view"

        figlet "${project}"

        if command -v "${fn}" &>/dev/null; then
            eval "${fn} ${workloads}"
        else
            # `kubens sugarconnect` is not working: https://sugarcrm.atlassian.net/browse/OPS-19491
            # kubens "${project}"
            # kubectl get "${workloads}"
            kubectl --context "k8s-${region}-${cluster}" -n "${project}" get "${workloads}"
        fi
    done
}
