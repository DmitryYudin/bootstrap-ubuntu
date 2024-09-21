#!/usr/bin/env bash

set -eu -o pipefail

snap install alacritty --classic

cat <<EOT
-------------------------------------------------------------------------------
$(alacritty --version)
-------------------------------------------------------------------------------
EOT
