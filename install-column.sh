#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

#URL=https://mirrors.edge.kernel.org/pub/linux/utils/util-linux
URL=https://mirrors.dotsrc.org/linux/utils/util-linux
TAG=$(curl -fsSL $URL/ | grep '<a href="v' | cut -d\" -f2 | tr -d / | sort -rV | head -n1)

# The 'column' utility from the 'bsdmainutils' package is too old for us. We detect it as a variant wich does not recognize
# '--version' option. The "new" version is a part of 'util-linux' project, but excluded from the package distribution.
if command -v column >/dev/null && column --version 2>&1 >/dev/null; then
    VER=$(column --version | cut -d' ' -f4)
    [[ v$VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
tmpdir=$(mktemp -d)
curl -fsSL $URL/$TAG/util-linux-${TAG#v}.tar.gz | \
    tar -C $tmpdir -xzf -

echo "Building"
cd $tmpdir/util-linux-*
CFLAGS=-Os CXXFLAGS=$CFLAGS ./configure --disable-liblastlog2 --disable-shared --quiet
make -s column -j$(nproc) && strip column && mv column /usr/local/bin/
rm -rf -- $tmpdir

cat <<EOT
-------------------------------------------------------------------------------
$(column --version)
-------------------------------------------------------------------------------
EOT
