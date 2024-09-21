#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

TAG=$(curl -fsSL https://dl.k8s.io/release/stable.txt)

if command -v kubectl >/dev/null; then
    VER=$(kubectl version --client=true | head -n1 | cut -d' ' -f3 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://dl.k8s.io/release/$TAG/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
chmod a+x /usr/local/bin/kubectl

cat <<EOT
-------------------------------------------------------------------------------
$(kubectl version --client=true)
-------------------------------------------------------------------------------
EOT


