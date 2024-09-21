#!/usr/bin/env bash

set -eu -o pipefail

usage() {
    cat <<EOT
A 'conan search [pkg]' wrapper with interactive repo selection.
EOT
}

entrypoint()
{
    local pkg=
    while [[ $# != 0 ]]; do
        case $1 in
            -h|--help) usage; exit;;
            *)  if [[ -z $pkg ]]; then pkg=$1; else echo "error: unrecognized option $1" >&2 && exit 1; fi;;
        esac
        shift
    done
    local pattern="$pkg/*"

    banner "All remotes"
    conan remote list

    local repos=$(conan remote list | grep -v 'Disabled: True')
    [[ -z $repos ]] && echo "no repos enabled" >&2 && exit 1
    local n=$(echo "$repos" | wc -l)
    if [[ $n == 1 ]]; then
        REPLY=1
    else
        banner "All enabled remotes"
        echo "$repos" | nl -n ln -s' ' -w 2
        while :; do
            read -p "Please select [1-$n]:"
            [[ 1 -le $REPLY && $REPLY -le $n ]] && break;
        done
    fi
    local repo=$(echo "$repos" | tail -n +$REPLY | grep -m 1 '.*' | cut -d: -f1)
    banner "search: $repo for '$pattern'"
    conan search "$pattern" -r $repo
}

banner() {
cat <<EOT
===============================================================================
$*
===============================================================================
EOT
}

entrypoint "$@"
