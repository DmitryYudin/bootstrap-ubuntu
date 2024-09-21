#!/bin/bash

set -ue -o pipefail

usage() {
    cat <<EOT
Dump package dependencies

$(basename $0) [pkg] [options]

Options:
    -h|--help       Print this help
    [pkg]           Package name. The default is a project root which is '../..'.
                    If name specified the remote set to 'conancenter'.
    -r|--remote X   Remote name

Example
    ./conan-deps.sh <path-to-conanfile.py>
    ./conan-deps.sh zlib/1.3.1
    ./conan-deps.sh folly/2022.01.31.00
EOT
}

entrypoint()
{
    local pkg= remote=
    while [[ $# != 0 ]]; do
        local nargs=1
        case $1 in
            -h|--help) usage; exit;;
            -r|--remote) remote=$2 nargs=2;;
            '') ;;
            *)
                if [[ -z $pkg ]]; then
                    pkg=${1/%@/}@
                    [[ -z $remote ]] && remote=conancenter
                else
                    echo "error: unrecognized option $1" >&2 && exit 1
                fi
            ;;
        esac
        shift $nargs
    done
    [[ -z $pkg ]] && echo "error: package name not set" >&2 && exit 1

    conan info --dry-build --json /tmp/out.json $pkg ${remote:+--remote $remote} 1>&2

    </tmp/out.json yq -o yaml '.[] | {
        .reference: [
            (.required_by // [])    | sort | . style="flow",
            (.requires // [])       | sort | . style="flow",
            (.build_requires // []) | sort | . style="flow"
] | . style="flow" }' | while read pkg rest; do
        printf "%-50s %s\n" "$pkg" "$rest"
    done

: <<'EOT'
    </tmp/out.json yq -o yaml '.[] | [
        .reference,
        (.required_by // []) | sort,
        (.requires // []) | sort,
        (.build_requires // []) | sort
] | . style="flow"' | while read pkg rest; do
        printf "%-50s %s\n" "$pkg" "$rest"
    done >info.yaml
EOT
: <<'EOT'
    </tmp/out.json yq -o yaml '.[] | {
        "reference": .reference,
        "required_by": .required_by // [],
        "requires": .requires // [],
        "build_requires": .build_requires // []
} | . style="flow"' >info.yaml
EOT

    # ENTRYPOINT_POST_MESSAGE="build-deps.yaml generated: pkg: [ref_by][refs][build_refs]"
    ENTRYPOINT_POST_MESSAGE="done. Format: 'pkg: [ref_by][refs][build_refs]'"
}

SECONDS_START=$(date +%s)
ENTRYPOINT_POST_MESSAGE=done
entrypoint "$@"
echo "$(date +%H:%M:%S -u -d @$(( $(date +%s) - SECONDS_START ))) $ENTRYPOINT_POST_MESSAGE" >&2
