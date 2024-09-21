#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

VERSION=${1:-}
: ${VERSION:?not set}

apt install lsb-release wget software-properties-common gpg

curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key >/etc/apt/trusted.gpg.d/apt.llvm.org.asc
curl -fsSL https://apt.llvm.org/llvm.sh | \
        sed 's,^set -eux,set -eu,g' | \
        bash -s - $VERSION

apt install -y clang-format-$VERSION clang-tidy-$VERSION

echo -----------------------------------------------------------
dpkg --list | grep compiler | grep clang | column -t
echo -----------------------------------------------------------
clang --version | head -n1
clang-format --version
echo -----------------------------------------------------------
