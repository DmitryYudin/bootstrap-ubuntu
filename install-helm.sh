#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

NAME=helm/helm
TAG=$(./github-latest-release.sh $NAME)
BUNDLE=helm-$TAG-linux-amd64.tar.gz

if command -v helm >/dev/null; then
    VER=$(helm version --short | cut -d'+' -f1 || true)
    [[ $VER == $TAG ]] && echo "already latest release $VER" && exit 0
fi

###############################################################################
# Recomended way:  wget -O - https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
###############################################################################
echo "Downloading $TAG"
curl -fsSL https://get.helm.sh/$BUNDLE | \
        tar -xzf - -C /usr/local/bin linux-amd64/helm --transform 's/linux-amd64\///'

cat <<EOT
-------------------------------------------------------------------------------
$(helm version --short)
-------------------------------------------------------------------------------
EOT
