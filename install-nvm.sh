#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
#[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=nvm-sh/nvm
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=install.sh

if [[ -d ~/.nvm ]]; then
    . $NVM_DIR/nvm.sh

    VER=$(nvm --version || true)
    [[ v$VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://raw.githubusercontent.com/$NAME/$TAG/$BUNDLE | bash

cat <<'EOT'

To make it works, please copy NVM related code from ~/.bashrc to ~/.profile and restart shell

EOT

. $NVM_DIR/nvm.sh
cat <<EOT
-------------------------------------------------------------------------------
$(nvm --version)
-------------------------------------------------------------------------------
EOT
