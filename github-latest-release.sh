#!/usr/bin/env bash

set -eu -o pipefail

usage()
{
    cat <<EOT
Print latest repo tag

$(basename $0) user/repo

Examples:
    $(basename $0) mikefarah/yq
    $(basename $0) microsoft/monaco-editor

EOT
}

case ${1:-} in -h|--help) usage; exit;; esac
[[ $# == 0 ]] && usage >&2 && exit 1
url=https://api.github.com/repos/$1/releases
curl -fsSL "$url" -o - | grep '"tag_name": ' | head -n1 | cut -d: -f2 | cut -d\" -f2
