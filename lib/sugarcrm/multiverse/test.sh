#!/usr/bin/env zsh

set +o allexport
set -o errexit
set -o nounset
set -o pipefail

doit::sugarcrm::multiverse::test::usage() {
    echo "Usage: doit sugarcrm multiverse test -p project1,project2,...,projectN" 1>&2
    exit ${1:-0}
}

doit::sugarcrm::multiverse::test() {
    local projects

    while getopts h:p: opt; do
        case "${opt}" in
        h)
            doit::sugarcrm::multiverse::test::usage 0
            ;;
        p)
            projects=${OPTARG}
            ;;
        * | \? | :)
            doit::sugarcrm::multiverse::test::usage 1
            ;;
        esac
    done

    if [[ -z "${projects}" ]]; then
        doit::sugarcrm::multiverse::test::usage 1
    fi

    (
        cd "${MULTIVERSE}"
        make go-gazelle
    )

    for project in $(echo ${projects} | sed "s/,/ /g"); do
        figlet "${project}"
        doit::sugarcrm::multiverse::test::project "${project}"
    done
}

doit::sugarcrm::multiverse::test::project() {
    local project=$1
    local cmd="doit::sugarcrm::multiverse::projects::${project}::test"

    if command -v "${cmd}" &>/dev/null; then
        eval "${cmd}"
    else
        (
            cd "${MULTIVERSE}"
            bazel test //projects/${project}/...
        )
    fi
}
