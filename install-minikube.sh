#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=kubernetes/minikube
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=minikube-linux-amd64

if command -v minikube >/dev/null; then
    VER=$(minikube version --short || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

echo "Downloading $TAG"
curl -fsSL https://github.com/$NAME/releases/download/$TAG/$BUNDLE -o /usr/local/bin/minikube
chmod a+x /usr/local/bin/minikube

cat <<EOT
-------------------------------------------------------------------------------
$(minikube version --short)
-------------------------------------------------------------------------------
EOT
