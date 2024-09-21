#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1

: ${NVM_DIR:?not set, please install NVM}
VERSION=${1:-}
: ${VERSION:?not set}

. $NVM_DIR/nvm.sh

nvm install $VERSION
nvm use $VERSION
npm config set -g loglevel=error
npm config set -g fund=false
npm config list

cat <<EOT
-----------------------------------------------------------
node $(node --version)
npm $(npm --version)

$(nvm list)
-----------------------------------------------------------
EOT
