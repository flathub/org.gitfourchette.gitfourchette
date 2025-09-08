#!/usr/bin/env bash
set -ex
flatpak-spawn --host /usr/bin/env \
    --ignore-environment \
    "DISPLAY=$DISPLAY" \
    "HOME=$HOME" \
    "GNUPGHOME=$GNUPGHOME" \
    "PINENTRY_USER_DATA=$PINENTRY_USER_DATA" \
    gpg "$@"
