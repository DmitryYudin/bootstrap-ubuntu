#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

./register-apt-repo.sh https://apt.fury.io/wez https://apt.fury.io/wez/gpg.key --key wezterm.key --release '*' --comp '*'

apt update
apt install -y wezterm

cat <<EOT
-------------------------------------------------------------------------------
$(wezterm --version)
-------------------------------------------------------------------------------
EOT
