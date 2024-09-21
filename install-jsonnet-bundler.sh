#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=jsonnet-bundler/jsonnet-bundler
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=jb-linux-amd64

if command -v jb >/dev/null; then
    VER=$(jb --version 2>&1 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE -o /usr/local/bin/jb
chmod a+x /usr/local/bin/jb

cat <<EOT
-------------------------------------------------------------------------------
$(jb --version 2>&1)
-------------------------------------------------------------------------------
EOT
