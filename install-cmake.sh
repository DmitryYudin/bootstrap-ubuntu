#!/usr/bin/env bash

set -eu -o pipefail

[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

curl -sL https://apt.kitware.com/kitware-archive.sh | bash -
apt -y install cmake

cat <<EOT
-------------------------------------------------------------------------------
$(cmake --version | head -n1)
-------------------------------------------------------------------------------
EOT
