#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

NAME=ip7z/7zip
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=-linux-x86.tar.xz  # => 7z2409-linux-x86.tar.xz

if command -v 7zzs >/dev/null; then
    VER=$(7zzs i | tail -n+2 | head -n1 | cut -d' ' -f3 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/7z${TAG//./}$BUNDLE | \
        tar -xJf - -C /usr/local/bin 7zzs

cat <<EOT
-------------------------------------------------------------------------------
$(7zzs i | tail -n+2 | head -n1)
-------------------------------------------------------------------------------
EOT
