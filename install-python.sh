#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

VERSION=${1:-}
: ${VERSION:?not set}

apt install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt install python3.$VERSION

echo -----------------------------------------------------------
python3.$VERSION --version
echo -----------------------------------------------------------
