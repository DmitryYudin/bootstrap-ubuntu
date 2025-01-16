#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

./register-apt-repo.sh https://cloud.r-project.org/bin/linux/ubuntu https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc --release "$(lsb_release -cs)-cran40/"

apt update
apt install -y r-base r-base-dev

hash -r
#R --quiet --no-echo -e "install.packages('dplyr', dependencies = FALSE, quiet = TRUE, verbose = TRUE)"
#R --quiet --no-echo -e "install.packages('tidytable', dependencies = FALSE, quiet = TRUE, verbose = TRUE)"

cat <<EOT
-------------------------------------------------------------------------------
$(R --version | head -n1)
$(R --quiet --no-echo -e '
    options(width=1000)
    installed.packages(.Library, priority = "high") [, c(1,3:5)]
')
-------------------------------------------------------------------------------
EOT
