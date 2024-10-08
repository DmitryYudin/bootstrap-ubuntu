#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=ninja-build/ninja
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=ninja-linux.zip

if command -v ninja >/dev/null; then
    VER=$(ninja --version || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE -O; unzip -o $BUNDLE -d /usr/local/bin
rm $BUNDLE

cat <<EOT
-------------------------------------------------------------------------------
$(ninja --version)
-------------------------------------------------------------------------------
EOT
