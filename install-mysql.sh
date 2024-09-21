#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1
[[ $UID != 0 ]] && echo "error: please, restart as root" >&2 && exit 1

entrypoint()
{
    banner "Detect latest version"
    MYSQL_APT_CONFIG=$(curl -fsSL https://dev.mysql.com/downloads/repo/apt/ | grep -m1 -o 'file=mysql-apt-config_.*deb' | cut -d= -f2)

    banner "Download '$MYSQL_APT_CONFIG'"
    curl -fsSL https://dev.mysql.com/get/$MYSQL_APT_CONFIG -o $MYSQL_APT_CONFIG

    banner "Run console installer"
    dpkg -i $MYSQL_APT_CONFIG
    rm $MYSQL_APT_CONFIG
    apt update
    apt install -y mysql-server

    banner "Mysql-workbench may require python update, register repo to facilitate this"
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    apt --fix-broken install -y

    banner "Install mysql-workbench. Only available from snap since 20.04"
    sudo snap install mysql-workbench-community

    banner "Install dbeaver-ce"
    add-apt-repository -y ppa:serge-rider/dbeaver-ce
    apt install -y dbeaver-ce

    banner "Check service status"
    service mysql status

    local WORKBENCH_USER=mysql
    local WORKBENCH_PASS=mypass
    banner "Register default workbench user"
    mysql <<EOT
        create user if not exists '$WORKBENCH_USER'@'localhost' identified by '$WORKBENCH_PASS';
        create user if not exists '$WORKBENCH_USER'@'%' identified by '$WORKBENCH_PASS';
        grant all on *.* to '$WORKBENCH_USER'@'localhost';
        grant all on *.* to '$WORKBENCH_USER'@'%';
        flush privileges;
EOT

    banner "Register login user '$SUDO_USER' without password"
    mysql <<EOT
        create user if not exists '$SUDO_USER';
        grant all on *.* to '$SUDO_USER'@'%';
        flush privileges;
EOT

    banner "Users"
    mysql <<EOT
        select user, host from mysql.user order by host;
EOT
}

mysql() { command mysql --no-beep --table --unbuffered "$@"; }
banner() {
    local delim================================================================================
    printf "%s\n%s\n%s\n" "$delim" "$*" "$delim" >&2
}

SECONDS_START=$(date +%s)
ENTRYPOINT_POST_MESSAGE=done
entrypoint "$@"
echo "$(date +%H:%M:%S -u -d @$(( $(date +%s) - SECONDS_START ))) $ENTRYPOINT_POST_MESSAGE" >&2
