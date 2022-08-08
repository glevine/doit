#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

chores::sugarcrm::multiverse::test::usage() {
    echo "Usage: chores sugarcrm multiverse test -p project1,project2,...,projectN" 1>&2
    exit ${1:-0}
}

chores::sugarcrm::multiverse::test() {
    local projects

    while getopts h:p: opt; do
        case "${opt}" in
        h)
            chores::sugarcrm::multiverse::test::usage 0
            ;;
        p)
            projects=${OPTARG}
            ;;
        * | \? | :)
            chores::sugarcrm::multiverse::test::usage 1
            ;;
        esac
    done

    if [[ -z "${projects}" ]]; then
        chores::sugarcrm::multiverse::test::usage 1
    fi

    for project in $(echo ${projects} | sed "s/,/ /g"); do
        figlet "${project}"
        eval "chores::sugarcrm::multiverse::projects::${project}::test"
    done
}
