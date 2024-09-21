#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=peak/s5cmd
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=s5cmd_${TAG#v}_Linux-64bit.tar.gz

if command -v s5cmd >/dev/null; then
    VER=$(s5cmd version | cut -d- -f1 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE |
        tar -xzf - -C /usr/local/bin s5cmd

cat <<EOT
-------------------------------------------------------------------------------
$(s5cmd version)
-------------------------------------------------------------------------------
EOT
