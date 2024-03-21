#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

doit::sugarcrm::multiverse::view::usage() {
    echo "Usage: doit sugarcrm multiverse view [-c cluster] [-r region] [-w workload1,workload2,...,workloadN] -p project1,project2,...,projectN" 1>&2
    exit ${1:-0}
}

doit::sugarcrm::multiverse::view() {
    local cluster="dev"
    local projects
    local region="usw2"
    local workloads="all"

    while getopts c:hp:r:w: opt; do
        case "${opt}" in
        c)
            cluster=${OPTARG}
            ;;
        h)
            doit::sugarcrm::multiverse::view::usage 0
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
            doit::sugarcrm::multiverse::view::usage 1
            ;;
        esac
    done

    if [[ -z "${projects}" ]]; then
        doit::sugarcrm::multiverse::view::usage 1
    fi

    kubectx "k8s-${region}-${cluster}"

    for project in $(echo ${projects} | sed "s/,/ /g"); do
        figlet "${project}"
        doit::sugarcrm::multiverse::view::project "${project}" "${workloads}"
    done
}

doit::sugarcrm::multiverse::view::project() {
    local project=$1
    local workloads=$2
    local cmd="doit::sugarcrm::multiverse::projects::${project}::view"

    if command -v "${cmd}" &>/dev/null; then
        eval "${cmd} ${workloads}"
    else
        # `kubens sugarconnect` is not working: https://sugarcrm.atlassian.net/browse/OPS-19491
        # kubens "${project}"
        # kubectl get "${workloads}"
        kubectl -n "${project}" get "${workloads}"
    fi
}
