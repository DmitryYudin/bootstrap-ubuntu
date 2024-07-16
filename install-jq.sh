#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=jqlang/jq
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=jq-linux-amd64

if command -v jq >/dev/null; then
    VER=$(jq --version || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE -o /usr/local/bin/jq
chmod a+x /usr/local/bin/jq

cat <<EOT
-------------------------------------------------------------------------------
$(jq --version)
-------------------------------------------------------------------------------
EOT
