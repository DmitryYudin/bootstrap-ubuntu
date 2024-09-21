#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1

entrypoint()
{
    [[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

    # https://docs.docker.com/engine/install/ubuntu/
    ./register-apt-repo.sh https://download.docker.com/linux/ubuntu \
            https://download.docker.com/linux/ubuntu/gpg -k docker.asc -c stable

    apt -y update
    apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    #update-daemon-json

    systemctl enable docker.service
    systemctl enable containerd.service

    groupadd -f docker
    usermod -aG docker $SUDO_USER
    sg docker "docker run hello-world"

    if ! groups $SUDO_USER | grep -q ' docker'; then
        echo "reboot required"
    fi

    ENTRYPOINT_POST_MESSAGE=$(docker --version)
}

update-daemon-json() {
    cat <<'EOT' >/etc/docker/daemon.json
{
    "mtu": 1420,
    "dns": ["127.0.0.53"]
}
EOT
}

SECONDS_START=$(date +%s)
ENTRYPOINT_POST_MESSAGE=done
entrypoint "$@"
echo "$(date +%H:%M:%S -u -d @$(( $(date +%s) - SECONDS_START ))) $ENTRYPOINT_POST_MESSAGE" >&2
