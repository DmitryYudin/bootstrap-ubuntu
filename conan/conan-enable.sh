#!/usr/bin/env bash

set -eu -o pipefail

entrypoint()
{
    banner "All disabled remotes"
    local repos=$(conan remote list | grep 'Disabled: True')
    [[ -z $repos ]] && echo "no repos disabled" >&2 && exit 1
    echo "$repos" | nl -n ln -s' ' -w 2
    local n=$(echo "$repos" | wc -l)
    while :; do
        read -p "Please select [1-$n]:"
        [[ 1 -le $REPLY && $REPLY -le $n ]] && break;
    done
    local repo=$(echo "$repos" | tail -n +$REPLY | grep -m 1 '.*' | cut -d: -f1)
    banner "enable: $repo"
    conan remote enable $repo
}

banner() {
cat <<EOT
===============================================================================
$*
===============================================================================
EOT
}

entrypoint "$@"
