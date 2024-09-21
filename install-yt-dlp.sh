#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=yt-dlp/yt-dlp
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=yt-dlp_linux

if command -v yt-dlp >/dev/null; then
    VER=$(yt-dlp --version || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE -o /usr/local/bin/yt-dlp
chmod a+x /usr/local/bin/yt-dlp

cat <<EOT
-------------------------------------------------------------------------------
$(yt-dlp --version)
-------------------------------------------------------------------------------
EOT
