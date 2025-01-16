#!/usr/bin/env bash

set -eu -o pipefail
[[ $UID != 0 ]] && echo "error: please, run as root" >&2 && exit 1

DEFAULT_SUITE=$(lsb_release -cs)
DEFAULT_COMPONENTS=main
REGISTRY=/etc/apt/sources.list.d
KEYRING=/etc/apt/keyrings
# KEYRING=/usr/share/keyrings # managed by package

usage()
{
    cat <<EOT
Register APT repo signed by a key in a $REGISTRY registry

$(basename $0) repo_url key_url [-k key_name] [-c components]

Options:
    -h|--help       Print this help
    -k|--key        A name to store a key to keyring=$KEYRING/ (default: filename(\$key_url))
    -s|--suite      Suite name (default: $DEFAULT_SUITE)
    -r|--release    Same as '--suite'
    -c|--comp       List of repo components (default: "$DEFAULT_COMPONENTS")

Examples:
    $(basename $0) http://packages.ros.org/ros2/ubuntu          https://raw.githubusercontent.com/ros/rosdistro/master/ros.key
    $(basename $0) https://dl.winehq.org/wine-builds/ubuntu     https://dl.winehq.org/wine-builds/winehq.key
    $(basename $0) https://apt.fury.io/wez                      https://apt.fury.io/wez/gpg.key              -k wezterm.key -c '*' -r '*' 
    $(basename $0) https://download.docker.com/linux/ubuntu     https://download.docker.com/linux/ubuntu/gpg -k docker.asc  -c stable

Note, 'suite' can specify an exact path, in which case the 'components' must be omitted and suite must
end with a slash (/). If suite does not specify an exact path, at least one component must be present.
See https://manpages.ubuntu.com/manpages/jammy/man5/sources.list.5.html for more details.

EOT
}

entrypoint()
{
    [[ $# == 0 ]] && usage && exit 1

    local repo= key_url= key_name= suite=$DEFAULT_SUITE components=$DEFAULT_COMPONENTS
    while [[ $# != 0 ]]; do
        local nargs=1
        case $1 in
            -h|--help) usage; exit;;
            -k|--key)  key_name=$2; nargs=2;;
            -r|--release) suite=$2; nargs=2;;
            -c|--comp) components=$2; nargs=2;;
            *)
                if [[ -z $repo ]]; then
                    repo=$1
                elif [[ -z $key_url ]]; then
                    key_url=$1
                else
                    echo "error: unknown option '$1'" >&2 && exit 1
                fi
        esac
        shift $nargs
    done
    : ${repo:?not set}
    : ${key_url:?not set}
    [[ -z $key_name ]] && key_name=${key_url##*/}

    if [[ $suite == ${suite%/} ]]; then
        [[ -z $components ]] && echo "error: 'components' must not be empty" >&2 && exit 1
    else
        components=
    fi
    register-repo $repo $key_url "$key_name" "$suite" "$components"
}

register-repo() # https://stackoverflow.com/questions/68992799/warning-apt-key-is-deprecated-manage-keyring-files-in-trusted-gpg-d-instead
{
    local repo=$1           # http://packages.ros.org/ros2/ubuntu
    local key_url=$2        # https://raw.githubusercontent.com/ros/rosdistro/master/ros.key
    local key_name=$3       # ros-archive-keyring.gpg
    local suite=$4
    local components=$5     # main, stable ...
    local list=${key_name%.*}.list
    # download and register a key
    curl -fsSL $key_url -o $KEYRING/$key_name
    local arch=$(dpkg --print-architecture)
    # register repo signed by a key
    >$REGISTRY/$list echo "deb [arch=$arch signed-by=$KEYRING/$key_name] $repo $suite $components"
}

entrypoint "$@"
