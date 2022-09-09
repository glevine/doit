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

    (
        cd "${MULTIVERSE}"
        make go-gazelle
    )

    for project in $(echo ${projects} | sed "s/,/ /g"); do
        local fn="chores::sugarcrm::multiverse::projects::${project}::test"

        figlet "${project}"

        if command -v "${fn}" &>/dev/null; then
            eval "${fn}"
        else
            chores::sugarcrm::multiverse::test::project "${project}"
        fi
    done
}

chores::sugarcrm::multiverse::test::project() {
    (
        cd "${MULTIVERSE}"
        bazel test //projects/${1}/...
    )
}
