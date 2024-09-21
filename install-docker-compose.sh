#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

TAG=$(./github-latest-release.sh docker/compose)
if command -v docker-compose >/dev/null; then
    VER=$(docker-compose version | cut -d' ' -f4 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/docker/compose/releases/download/$TAG/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod a+x /usr/local/bin/docker-compose

cat <<EOT
-------------------------------------------------------------------------------
$(docker-compose version)
-------------------------------------------------------------------------------
EOT
