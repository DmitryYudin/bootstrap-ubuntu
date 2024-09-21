#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=genuinetools/reg
TAG=$(./github-latest-release.sh $NAME)

if command -v reg >/dev/null; then
    VER=$(reg version | grep -m1 version | tr -d ' ' | cut -d: -f2 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/reg-linux-amd64 -o /usr/local/bin/reg
chmod a+x /usr/local/bin/reg

cat <<EOT
-------------------------------------------------------------------------------
$(reg version)
-------------------------------------------------------------------------------
EOT
