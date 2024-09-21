#!/usr/bin/env bash

email=${1:-}
: ${email:?not set}

ssh-keygen -t ed25519 -C "$email" -f id_ed25519
