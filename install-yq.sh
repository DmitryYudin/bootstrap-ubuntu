#!/usr/bin/env bash

set -eu -o pipefail

[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

curl -s -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64.tar.gz | \
        tar --transform s/_linux_amd64// -xzf - -C /usr/local/bin ./yq_linux_amd64

cat <<EOT
-------------------------------------------------------------------------------
$(yq --version)
-------------------------------------------------------------------------------
EOT
