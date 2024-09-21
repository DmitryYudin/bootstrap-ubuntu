#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

./register-apt-repo.sh https://packages.redis.io/deb \
        https://packages.redis.io/gpg -k redis-archive-keyring.asc -c main

apt update
apt install redis-tools

cat <<EOT
-------------------------------------------------------------------------------
$(redis-cli --version)
-------------------------------------------------------------------------------
EOT
