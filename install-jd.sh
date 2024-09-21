#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=josephburnett/jd
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=jd-amd64-linux

if command -v jd >/dev/null; then
    VER=$(jd --version | cut -d' ' -f3 || true)
    [[ v$VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE -o /usr/local/bin/jd
chmod a+x /usr/local/bin/jd

cat <<EOT
-------------------------------------------------------------------------------
$(jd --version)
-------------------------------------------------------------------------------
EOT
