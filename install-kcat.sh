#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

apt install -y kafkacat

! command -v kcat && ln -s $(which kafkacat) /usr/local/bin/kcat

cat <<EOT
-------------------------------------------------------------------------------
$(kcat -V | grep Version)
-------------------------------------------------------------------------------
EOT
