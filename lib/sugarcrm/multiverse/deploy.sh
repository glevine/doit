#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::deploy::usage() {
    echo "Usage: chores sugarcrm multiverse deploy -p project1,project2,...,projectN" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::multiverse::deploy() {
    local projects

    while getopts h:p: opt; do
        case "${opt}" in
        h)
            chores::sugarcrm::multiverse::deploy::usage 0
            ;;
        p)
            projects=${OPTARG}
            ;;
        * | \? | :)
            chores::sugarcrm::multiverse::deploy::usage 1
            ;;
        esac
    done

    if [[ -z "${projects}" ]]; then
        chores::sugarcrm::multiverse::deploy::usage 1
    fi

    kubectx k8s-usw2-dev

    for project in $(echo ${projects} | sed "s/,/ /g"); do
        figlet "${project}"
        eval "chores::sugarcrm::multiverse::projects::${project}::deploy"
    done
}
