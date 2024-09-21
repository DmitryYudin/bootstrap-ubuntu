#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

NAME=mikefarah/yq
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=yq_linux_amd64.tar.gz

if command -v yq >/dev/null; then
    VER=$(yq --version | cut -d' ' -f4 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE | \
        tar -xzf - -C /usr/local/bin yq_linux_amd64 --transform s/_linux_amd64//

cat <<EOT
-------------------------------------------------------------------------------
$(yq --version)
-------------------------------------------------------------------------------
EOT
