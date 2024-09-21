#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=google/yamlfmt
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=yamlfmt_${TAG#v}_Linux_x86_64.tar.gz

if command -v yamlfmt >/dev/null; then
    VER=$(yamlfmt --version | cut -d' ' -f2 || true)
    [[ v$VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE |
        tar -xzf - -C /usr/local/bin yamlfmt

cat <<EOT
-------------------------------------------------------------------------------
$(yamlfmt --version)
-------------------------------------------------------------------------------
EOT
