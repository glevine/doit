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

    (
        cd "${MULTIVERSE}"
        make go-gazelle
    )

    kubectx k8s-usw2-dev

    for project in $(echo ${projects} | sed "s/,/ /g"); do
        local fn="chores::sugarcrm::multiverse::projects::${project}::deploy"

        figlet "${project}"

        if command -v "${fn}" &>/dev/null; then
            eval "${fn}"
        else
            chores::sugarcrm::multiverse::deploy::project "${project}"
        fi
    done
}

chores::sugarcrm::multiverse::deploy::project() {
    (
        cd "${MULTIVERSE}/k8s/${1}"
        kubens "${1}"
        skaffold run -p dev
    )
}
