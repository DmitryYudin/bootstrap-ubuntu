#!/usr/bin/env bash

set -eu -o pipefail

#[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1
# TODO: avoid auth popup, use sudo way
snap install alacritty --classic

cat <<EOT
-------------------------------------------------------------------------------
$(alacritty --version)
-------------------------------------------------------------------------------
EOT
