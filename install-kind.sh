#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=kubernetes-sigs/kind
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=kind-linux-amd64

if command -v kind >/dev/null; then
    VER=$(kind version | cut -d' ' -f2 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE -o /usr/local/bin/kind
chmod a+x /usr/local/bin/kind

cat <<EOT
-------------------------------------------------------------------------------
$(kind version)
-------------------------------------------------------------------------------
EOT
