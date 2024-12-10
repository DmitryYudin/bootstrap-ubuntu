#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

trap 'rm -f /tmp/popeye.log' EXIT; rm -f /tmp/popeye.log # Some additional stuff
remove-ascii-color() { sed -e 's/\x1b\[[0-9;]*m//g'; }   # to make it works

NAME=derailed/popeye
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=popeye_linux_amd64.tar.gz

if command -v popeye >/dev/null; then
    VER=$(popeye version | remove-ascii-color | grep Version: | tr -d ' ' | cut -d: -f2 || true)
    [[ v$VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE |
        tar -xzf - -C /usr/local/bin popeye

cat <<EOT
-------------------------------------------------------------------------------
$(popeye version | remove-ascii-color)
-------------------------------------------------------------------------------
EOT
