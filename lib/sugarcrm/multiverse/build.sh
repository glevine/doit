#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::build::usage() {
    echo "Usage: chores sugarcrm multiverse build -p project1,project2,...,projectN" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::multiverse::build() {
    local projects

    while getopts h:p: opt; do
        case "${opt}" in
        h)
            chores::sugarcrm::multiverse::build::usage 0
            ;;
        p)
            projects=${OPTARG}
            ;;
        * | \? | :)
            chores::sugarcrm::multiverse::build::usage 1
            ;;
        esac
    done

    if [[ -z "${projects}" ]]; then
        chores::sugarcrm::multiverse::build::usage 1
    fi

    (
        cd "${MULTIVERSE}"
        make go-gazelle
    )

    for project in $(echo ${projects} | sed "s/,/ /g"); do
        figlet "${project}"
        chores::sugarcrm::multiverse::build::project "${project}"
    done
}

chores::sugarcrm::multiverse::build::project() {
    local project=$1
    local cmd="chores::sugarcrm::multiverse::projects::${project}::build"

    if command -v "${cmd}" &>/dev/null; then
        eval "${cmd}"
    else
        (
            cd "${MULTIVERSE}"
            bazel build //projects/${project}/...
        )
    fi
}
