#!/usr/bin/env bash

set -eu -o pipefail

entrypoint()
{
    banner "All enabled remotes"
    local repos=$(conan remote list | grep -v 'Disabled: True')
    [[ -z $repos ]] && echo "no repos enabled" >&2 && exit 1
    echo "$repos" | nl -n ln -s' ' -w 2
    local n=$(echo "$repos" | wc -l)
    while :; do
        read -p "Please select [1-$n]:"
        [[ 1 -le $REPLY && $REPLY -le $n ]] && break;
    done
    local repo=$(echo "$repos" | tail -n +$REPLY | grep -m 1 '.*' | cut -d: -f1)
    banner "disable: $repo"
    conan remote disable $repo
}

banner() {
cat <<EOT
===============================================================================
$*
===============================================================================
EOT
}

entrypoint "$@"
