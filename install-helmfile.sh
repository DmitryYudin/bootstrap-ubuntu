#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=helmfile/helmfile
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=helmfile_${TAG#v}_linux_amd64.tar.gz

if command -v helmfile >/dev/null; then
    VER=$(helmfile --version | cut -d' ' -f3 || true)
    [[ v$VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE | \
        tar -xzf - -C /usr/local/bin helmfile

sudo -u $SUDO_USER helmfile init --force

cat <<EOT
-------------------------------------------------------------------------------
$(helmfile --version)
-------------------------------------------------------------------------------
EOT
