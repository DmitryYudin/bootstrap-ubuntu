#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

apt install -y postgresql-client

cat <<EOT
-------------------------------------------------------------------------------
$(psql --version)
-------------------------------------------------------------------------------
EOT
