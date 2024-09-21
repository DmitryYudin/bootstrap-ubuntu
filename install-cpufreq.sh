#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

apt install -y linux-tools-common cpufrequtils
apt install -y linux-tools-generic linux-cloud-tools-generic
apt install -y linux-tools-$(uname -r) linux-cloud-tools-$(uname -r)

cpufreq-info
cpupower frequency-info
