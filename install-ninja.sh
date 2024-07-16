#!/usr/bin/env bash

set -eu -o pipefail

[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

pkg=ninja-linux.zip
curl -s -L https://github.com/ninja-build/ninja/releases/latest/download/ninja-linux.zip -o $pkg
unzip -o $pkg -d /usr/local/bin
rm -f $pkg
cat <<EOT
-------------------------------------------------------------------------------
ninja $(ninja --version)
-------------------------------------------------------------------------------
EOT
