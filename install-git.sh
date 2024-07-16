#!/usr/bin/env bash

set -eu -o pipefail

[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

apt -y install software-properties-common
add-apt-repository -y ppa:git-core/ppa
apt install -y git git-lfs
git config --global http.sslverify false

cat <<EOT
-------------------------------------------------------------------------------
$(git --version)
-------------------------------------------------------------------------------
EOT
