#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

apt -y install pv

cat <<EOT
-------------------------------------------------------------------------------
$(pv --version | head -n1)
-------------------------------------------------------------------------------
EOT
