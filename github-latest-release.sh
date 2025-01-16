#!/usr/bin/env bash

set -eu -o pipefail

usage()
{
    cat <<EOT
Print latest repo release/tag

Usage:
    $(basename $0) [options] user/repo

Options:
    -h|--help           Print this help
    -t|--tag            Print tag (default: release)

Examples:
    $(basename $0) mikefarah/yq
    $(basename $0) https://github.com/microsoft/monaco-editor
    $(basename $0) --tag KDE/massif-visualizer

EOT
}

entrypoint()
{
    local url= tag=

    [[ $# == 0 ]] && usage >&2 && exit 1
    while [[ $# != 0 ]]; do
        local nargs=1
        case $1 in
            -h|--help) usage; exit;;
            -t|--tag) tag=1;;
            *)  if [[ -z $url ]]; then
                    url=$1
                else
                    echo "error: unrecognized option '$1'" >&2 && exit 1
                fi
        esac
        shift $nargs
    done
    : ${url:?not set}

    url=${url#*github.com/}
    url=https://api.github.com/repos/$url
    if [[ -z $tag ]]; then
        curl -fsSL "$url/releases" | grep '"tag_name": '
    else
        curl -fsSL "$url/tags" | grep '"name": ' 
    fi | grep -v '.*-rc.*' | sort -rV | head -n1 | cut -d: -f2 | cut -d\" -f2

}

entrypoint "$@"
