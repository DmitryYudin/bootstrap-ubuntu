#!/usr/bin/env bash

set -eu -o pipefail

SWAPFILE=/swapfile
SIZE=32 # Gb

entrypoint()
{
    [[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

    if [[ -f $SWAPFILE ]]; then
        echo "Remove existing swapfile '$SWAPFILE'"
        swapoff -v $SWAPFILE || true
        rm -f $SWAPFILE
    fi

    echo "Create swapfile '$SWAPFILE' of $SIZE Gb"
    dd if=/dev/zero of=$SWAPFILE bs=1024 count=$((SIZE*1024*1024))

    echo "Enable swapfile"
    chmod 600 $SWAPFILE

    echo "Swap on '$SWAPFILE'"
    mkswap $SWAPFILE
    swapon $SWAPFILE

    echo "Update /etc/fstab"
    if ! grep -q "^$SWAPFILE" /etc/fstab; then
        $SWAPFILE none swap sw 0 0 >/etc/fstab
    fi
}

SECONDS_START=$(date +%s)
ENTRYPOINT_POST_MESSAGE=done
entrypoint "$@"
echo "$(date +%H:%M:%S -u -d @$(( $(date +%s) - SECONDS_START ))) $ENTRYPOINT_POST_MESSAGE" >&2
