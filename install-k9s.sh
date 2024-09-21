#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=derailed/k9s
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=k9s_Linux_amd64.tar.gz

if command -v k9s >/dev/null; then
    VER=$(k9s version --short | grep Version | tr -s ' ' | cut -d' ' -f2 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE |
        tar -xzf - -C /usr/local/bin k9s

cat <<EOT
-------------------------------------------------------------------------------
$(k9s version --short)
-------------------------------------------------------------------------------
EOT
