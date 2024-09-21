#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=google/go-jsonnet
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=go-jsonnet_${TAG#v}_Linux_x86_64.tar.gz

if command -v jsonnet >/dev/null; then
    VER=$(jsonnet --version | cut -d' ' -f6 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE | \
        tar -xzf - -C /usr/local/bin jsonnet jsonnetfmt jsonnet-deps jsonnet-lint

cat <<EOT
-------------------------------------------------------------------------------
$(jsonnet --version)
$(jsonnetfmt --version)
-------------------------------------------------------------------------------
EOT
