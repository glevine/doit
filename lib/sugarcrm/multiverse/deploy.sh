#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

doit::sugarcrm::multiverse::deploy::usage() {
    echo "Usage: doit sugarcrm multiverse deploy -p project1,project2,...,projectN" 1>&2
    exit ${1:-0}
}

doit::sugarcrm::multiverse::deploy() {
    local projects

    while getopts hp: opt; do
        case "${opt}" in
        h)
            doit::sugarcrm::multiverse::deploy::usage 0
            ;;
        p)
            projects=${OPTARG}
            ;;
        * | \? | :)
            doit::sugarcrm::multiverse::deploy::usage 1
            ;;
        esac
    done

    if [[ -z "${projects}" ]]; then
        doit::sugarcrm::multiverse::deploy::usage 1
    fi

    (
        cd "${MULTIVERSE}"
        make go-gazelle
    )

    kubectx k8s-usw2-dev

    for project in $(echo ${projects} | sed "s/,/ /g"); do
        figlet "${project}"
        doit::sugarcrm::multiverse::deploy::project "${project}"
    done
}

doit::sugarcrm::multiverse::deploy::project() {
    local project=$1
    local cmd="doit::sugarcrm::multiverse::projects::${project}::deploy"

    if command -v "${cmd}" &>/dev/null; then
        eval "${cmd}"
    else
        (
            cd "${MULTIVERSE}/k8s/services/${project}"
            kubens "${project}"
            skaffold run -p dev --force=true
        )
    fi
}
