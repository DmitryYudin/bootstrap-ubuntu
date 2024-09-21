#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=norwoodj/helm-docs
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=helm-docs_${TAG#v}_Linux_x86_64.tar.gz

if command -v helm-docs >/dev/null; then
    VER=$(helm-docs --version | cut -d' ' -f3 || true)
    [[ v$VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE | \
        tar -xzf - -C /usr/local/bin helm-docs

cat <<EOT
-------------------------------------------------------------------------------
$(helm-docs --version)
-------------------------------------------------------------------------------
EOT
