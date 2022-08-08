#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::view::usage() {
    echo "Usage: chores sugarcrm multiverse view [-c cluster] -p project1,project2,...,projectN [-r region]" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::multiverse::view() {
    local cluster="dev"
    local projects
    local region="usw2"

    while getopts c:h:p:r: opt; do
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
        figlet "${project}"
        eval "chores::sugarcrm::multiverse::projects::${project}::view"
    done
}
