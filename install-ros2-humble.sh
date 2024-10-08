#!/usr/bin/env bash

set -eu -o pipefail && cd "$(dirname "$0")" >/dev/null 2>&1

DISTRO=humble

usage()
{
    cat <<EOT
Install ROS2 $DISTRO

$(basename $0) [r|d|u|-u|--remove|--delete|--uninstall] [i|-i|--install]

EOT
}

entrypoint()
{
    [[ $# == 0 ]] && usage && exit 1

    local do_install= do_remove=
    while [[ $# != 0 ]]; do
        case $1 in
            -h|--help) usage; exit;;
            i|-i|--install) do_install=1;;
            r|d|u|-u|--remove|--delete|--uninstall) do_remove=1;;
            *) echo "error: unknown option '$1'" >&2 && exit 1
        esac
        shift
    done
    [[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

    # https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html

    if [[ -n $do_remove ]]; then
        banner "Remove ROS2 $DISTRO"
        apt remove "ros-$DISTRO-"'*' || true
        apt update
        apt autoremove
    fi

    [[ -z $do_install ]] && return 0

    banner "Set locale and register repo"
    check-locale
    ./register-apt-repo.sh http://packages.ros.org/ros2/ubuntu https://raw.githubusercontent.com/ros/rosdistro/master/ros.key

    if :; then
        banner "Desktop Install (Recommended): ROS, RViz, demos, tutorials."
        apt install ros-$DISTRO-desktop
    else
        banner "ROS-Base Install (Bare Bones): Communication libraries, message packages, command line tools. No GUI tools."
        apt install ros-$DISTRO-ros-base
    fi

    banner "Development tools: Compilers and other tools to build ROS packages"
    apt install ros-dev-tools
}

check-locale()
{
    local wanted=en_US.UTF-8
    local l=$(locale | grep ^LANG= | cut -d= -f2)
    [[ $l == $wanted ]] && return

    apt update && apt install locales
    locale-gen en_US $wanted
    update-locale LC_ALL=$wanted LANG=$wanted

    export LANG=$wanted
    local l=$(locale | grep ^LANG= | cut -d= -f2)
    [[ $l == $wanted ]] && return

    echo "error: unable to set locale to '$wanted', current locale is '$l'" >&2 && exit 1
}

banner() {
    local delim================================================================================
    printf "%s\n%s\n%s\n" "$delim" "$*" "$delim" >&2
}

apt() { DEBIAN_FRONTEND=noninteractive apt-get -y "$@"; }

SECONDS_START=$(date +%s)
ENTRYPOINT_POST_MESSAGE=done
entrypoint "$@"
echo "$(date +%H:%M:%S -u -d @$(( $(date +%s) - SECONDS_START ))) $ENTRYPOINT_POST_MESSAGE" >&2
