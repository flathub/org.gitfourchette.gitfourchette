#!/usr/bin/env bash

exec flatpak-spawn --host --forward-fd=1 --forward-fd=2 umount "$@"
