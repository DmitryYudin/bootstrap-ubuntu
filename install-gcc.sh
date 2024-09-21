#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

VERSION=${1:-}
: ${VERSION:?not set}

apt install -y software-properties-common
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt install -y gcc-$VERSION g++-$VERSION

echo -----------------------------------------------------------
dpkg --list | grep compiler | grep gcc | column -t
echo -----------------------------------------------------------
gcc --version | head -n1
echo -----------------------------------------------------------
